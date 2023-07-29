part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkStatus() = _AuthCheckStatusEvent;
  const factory AuthEvent.register({
    required String username,
    required String password,
  }) = _AuthRegisterEvent;
  const factory AuthEvent.login({
    required String username,
    required String password,
  }) = _AuthLoginEvent;
  const factory AuthEvent.logout() = _AuthLogoutEvent;
}
