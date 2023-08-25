part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();

  const factory AuthEvent.checkStatus() = _AuthEvent$CheckStatus;
  const factory AuthEvent.register({
    required String username,
    required String password,
  }) = _AuthEvent$Register;
  const factory AuthEvent.login({
    required String username,
    required String password,
  }) = _AuthEvent$Login;
  const factory AuthEvent.logout() = _AuthEvent$Logout;
}

final class _AuthEvent$CheckStatus extends AuthEvent {
  const _AuthEvent$CheckStatus();
}

final class _AuthEvent$Register extends AuthEvent {
  const _AuthEvent$Register({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;
}

final class _AuthEvent$Login extends AuthEvent {
  const _AuthEvent$Login({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;
}

final class _AuthEvent$Logout extends AuthEvent {
  const _AuthEvent$Logout();
}
