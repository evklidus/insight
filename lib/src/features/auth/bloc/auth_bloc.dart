import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/src/common/utils/exception_to_message.dart';
import 'package:insight/src/common/utils/mixins/set_state_mixin.dart';
import 'package:insight/src/features/auth/data/auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>
    with SetStateMixin
    implements EventSink<AuthEvent> {
  AuthBloc(AuthRepository authRepository)
      : _authRepository = authRepository,
        super(const AuthState.idle(isAuthenticated: false)) {
    _authRepository.isAuthenticatedStream.map((isAuthenticated) {
      if (isAuthenticated) {
        setState(
          const AuthState.successful(
            isAuthenticated: false,
            message: 'Ваша сессия истекла',
          ),
        );
      }
    });

    on<AuthEvent>(
      (event, emit) => event.map(
        // TODO: разобраться стоит ли удалять checkStatus
        checkStatus: (event) => _checkStatus(emit),
        register: (event) => _register(event, emit),
        login: (event) => _login(event, emit),
        logout: (event) => _logout(emit),
      ),
      transformer: bloc_concurrency.droppable(),
    );
  }

  final AuthRepository _authRepository;

  Future<void> _checkStatus(Emitter<AuthState> emit) async {
    emit(AuthState.processing(isAuthenticated: state.isAuthenticated));
    try {
      final isAuthenticated = await _authRepository.checkAuthenticatedStatus();
      if (isAuthenticated) {
        emit(const AuthState.idle(isAuthenticated: true));
      } else {
        emit(const AuthState.idle(isAuthenticated: false));
      }
    } on Object catch (e) {
      emit(AuthState.error(
        isAuthenticated: state.isAuthenticated,
        message: exceptionToMessage(e),
      ));
      rethrow;
    } finally {
      emit(AuthState.idle(isAuthenticated: state.isAuthenticated));
    }
  }

  Future<void> _register(
    _AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(isAuthenticated: state.isAuthenticated));
    try {
      await _authRepository.register(
        event.username,
        event.password,
      );
      emit(AuthState.successful(
        isAuthenticated: state.isAuthenticated,
        message: 'Вы успешно зарегистрировались',
      ));
    } on Object catch (_) {
      emit(AuthState.error(
        isAuthenticated: state.isAuthenticated,
        message: 'Регистрация временно недоступна',
      ));
      rethrow;
    } finally {
      emit(AuthState.idle(isAuthenticated: state.isAuthenticated));
    }
  }

  Future<void> _login(
    _AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(isAuthenticated: state.isAuthenticated));
    try {
      await _authRepository.login(
        event.username,
        event.password,
      );
      emit(const AuthState.successful(
        isAuthenticated: true,
        message: 'Вы успешно вошли',
      ));
    } on Object catch (e) {
      emit(AuthState.error(
        isAuthenticated: state.isAuthenticated,
        message: exceptionToMessage(e),
      ));
      rethrow;
    } finally {
      emit(AuthState.idle(isAuthenticated: state.isAuthenticated));
    }
  }

  Future<void> _logout(
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(isAuthenticated: state.isAuthenticated));
    try {
      await _authRepository.logout();
      emit(const AuthState.idle(
        isAuthenticated: false,
        message: 'Вы успешно вышли',
      ));
    } on Object catch (e) {
      emit(AuthState.error(
        isAuthenticated: state.isAuthenticated,
        message: exceptionToMessage(e),
      ));
      rethrow;
    } finally {
      emit(AuthState.idle(isAuthenticated: state.isAuthenticated));
    }
  }
}
