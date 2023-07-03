import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/common/utilities/exception_to_message.dart';
import 'package:insight/features/auth/data/repositories/auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(const AuthState.idle()) {
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

  Future<void> _checkStatus(Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final isAuthenticated = await authRepository.checkAuthenticatedStatus();
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
      await authRepository.register(
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
      await authRepository.login(
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
      await authRepository.logout();
      emit(const AuthState.login());
    } catch (e) {
      emit(AuthState.error(exceptionToMessage(e)));
    }
  }
}
