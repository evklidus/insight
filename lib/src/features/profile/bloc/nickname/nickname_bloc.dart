import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/features/profile/bloc/nickname/nickname_state.dart';
import 'package:insight/src/features/profile/data/profile_repository.dart';

part 'nickname_event.dart';

class NicknameBloc extends Bloc<NicknameEvent, NicknameState>
    implements EventSink<NicknameEvent> {
  NicknameBloc({
    required ProfileRepository repository,
    NicknameState? initialState,
  })  : _repository = repository,
        super(
          initialState ?? const NicknameState.idle(data: null),
        ) {
    on<NicknameEvent>(
      (event, emit) => switch (event) {
        _NicknameEvent$Save() => _save(emit, event),
      },
    );
  }

  final ProfileRepository _repository;

  Future<void> _save(
    Emitter<NicknameState> emit,
    _NicknameEvent$Save event,
  ) async {
    try {
      emit(NicknameState.processing(data: event.newNickname));
      await _repository.editNickname(
        newNickname: event.newNickname,
        oldNickname: event.oldNickname,
      );
      event.onSuccess();
      emit(
        NicknameState.successful(
          data: state.data,
          message: 'Имя пользователя обновлено',
        ),
      );
    } on Object {
      event.onError();
      emit(
        NicknameState.error(
          data: event.oldNickname,
          message: 'Ошибка обновления имени пользователя',
        ),
      );
      rethrow;
    } finally {
      emit(NicknameState.idle(data: state.data));
    }
  }
}
