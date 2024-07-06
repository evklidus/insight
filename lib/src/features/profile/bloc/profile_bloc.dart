import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/features/profile/bloc/profile_state.dart';
import 'package:insight/src/features/profile/data/profile_repository.dart';
import 'package:insight/src/features/profile/model/user_edit.dart';

part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>
    implements EventSink<ProfileEvent> {
  ProfileBloc({
    required ProfileRepository repository,
    ProfileState? initialState,
  })  : _repository = repository,
        super(
          initialState ?? const ProfileState.idle(data: null),
        ) {
    on<ProfileEvent>(
      (event, emit) => switch (event) {
        _ProfileEvent$Fetch() => _fetch(emit),
        _ProfileEvent$Edit() => _edit(emit, event),
        _ProfileEvent$Clear() => _clear(emit),
      },
    );
  }

  final ProfileRepository _repository;

  Future<void> _fetch(Emitter<ProfileState> emit) async {
    try {
      emit(ProfileState.processing(data: state.data));
      final newData = await _repository.getUser();
      emit(
        ProfileState.successful(
          data: newData,
          message: 'Профиль получен',
        ),
      );
    } on Object {
      emit(
        ProfileState.error(
          data: state.data,
          message: 'Ошибка получения профиля',
        ),
      );
      rethrow;
    } finally {
      emit(ProfileState.idle(data: state.data));
    }
  }

  Future<void> _edit(
    Emitter<ProfileState> emit,
    _ProfileEvent$Edit event,
  ) async {
    final oldData = state.data;
    try {
      emit(
        ProfileState.processing(
          data: state.data?.copyWith(
            firstName: event.user.firstName,
            lastName: event.user.lastName,
          ),
        ),
      );
      await _repository.editUser(event.user);
      emit(
        ProfileState.successful(
          data: state.data,
          message: 'Профиль обновлен',
        ),
      );
    } on Object {
      // Делаем оптимистичны рендеринг. Получили ошибку - подставляем старые данные
      emit(
        ProfileState.error(
          data: oldData,
          message: 'Ошибка обновления профиля',
        ),
      );
      rethrow;
    } finally {
      emit(ProfileState.idle(data: state.data));
    }
  }

  void _clear(Emitter<ProfileState> emit) =>
      emit(const ProfileState.idle(data: null));
}
