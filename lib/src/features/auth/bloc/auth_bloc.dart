import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/src/common/utils/exception_to_message.dart';
import 'package:insight/src/common/utils/mixins/set_state_mixin.dart';
import 'package:insight/src/features/auth/data/auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with SetStateMixin {
  AuthBloc(AuthRepository authRepository)
      : _authRepository = authRepository,
        super(const AuthState.idle()) {
    _authRepository.isAuthenticatedStream.map((isAuthenticatedStream) =>
        isAuthenticatedStream
            ? setState(const AuthState.authorized())
            : setState(const AuthState.login()));

    on<AuthEvent>(
      (event, emit) => event.map(
        checkStatus: (event) => _checkStatus(emit),
        register: (event) => _register(event, emit),
        login: (event) => _login(event, emit),
        logout: (event) => _logout(emit),
        changeAuthTypeToLogin: (event) => emit(const AuthState.login()),
        changeAuthTypeToRegister: (event) => emit(const AuthState.register()),
      ),
    );
  }

  final AuthRepository _authRepository;

  Future<void> _checkStatus(Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final isAuthenticated = await _authRepository.checkAuthenticatedStatus();
      if (isAuthenticated) {
        emit(const AuthState.authorized());
      } else {
        emit(const AuthState.login());
      }
    } catch (e) {
      emit(AuthState.error(exceptionToMessage(e)));
    }
  }

  Future<void> _register(
    _AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.register(
        event.username,
        event.password,
      );
      emit(const AuthState.login());
    } catch (e) {
      emit(AuthState.error(exceptionToMessage(e)));
    }
  }

  Future<void> _login(
    _AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.login(
        event.username,
        event.password,
      );
      emit(const AuthState.authorized());
    } catch (e) {
      emit(AuthState.error(exceptionToMessage(e)));
    }
  }

  Future<void> _logout(
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.logout();
      emit(const AuthState.login());
    } catch (e) {
      emit(AuthState.error(exceptionToMessage(e)));
    }
  }
}
