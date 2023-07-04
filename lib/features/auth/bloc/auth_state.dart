part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.idle() = _AuthIdleState;
  const factory AuthState.loading() = _AuthLoadingState;
  const factory AuthState.register() = _AuthRegisterState;
  const factory AuthState.login() = _AuthLoginState;
  const factory AuthState.authorized() = _AuthAuthorizedState;
  const factory AuthState.error(String errorMsg) = _AuthErrorState;
}
