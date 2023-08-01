import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/src/features/profile/bloc/profile_state.dart';
import 'package:insight/src/features/profile/data/profile_repository.dart';

part 'profile_bloc.freezed.dart';
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
      (event, emit) => event.map<Future<void>>(
        fetch: (event) => _fetch(emit),
      ),
    );
  }

  final ProfileRepository _repository;

  Future<void> _fetch(Emitter<ProfileState> emit) async {
    try {
      emit(ProfileState.processing(data: state.data));
      // Для тестирования скелетона при разработке
      // await Future.delayed(const Duration(seconds: 5));
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
}
