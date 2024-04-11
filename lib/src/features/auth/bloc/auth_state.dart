part of 'auth_bloc.dart';

/// {@template auth_state_placeholder}
/// Entity placeholder for AuthState
/// {@endtemplate}
typedef AuthEntity = bool;

/// {@template auth_state}
/// AuthState.
/// {@endtemplate}
sealed class AuthState extends _$AuthStateBase {
  /// Idling state
  /// {@macro auth_state}
  const factory AuthState.idle({
    required AuthEntity? isAuthenticated,
    String message,
  }) = AuthState$Idle;

  /// Processing
  /// {@macro auth_state}
  const factory AuthState.processing({
    required AuthEntity? isAuthenticated,
    String message,
  }) = AuthState$Processing;

  /// Successful
  /// {@macro auth_state}
  const factory AuthState.successful({
    required AuthEntity? isAuthenticated,
    String message,
  }) = AuthState$Successful;

  /// An error has occurred
  /// {@macro auth_state}
  const factory AuthState.error({
    required AuthEntity? isAuthenticated,
    String message,
  }) = AuthState$Error;

  /// {@macro auth_state}
  const AuthState({required super.isAuthenticated, required super.message});
}

/// Idling state
final class AuthState$Idle extends AuthState with _$AuthState {
  const AuthState$Idle({
    required super.isAuthenticated,
    super.message = 'Idling',
  });
}

/// Processing
final class AuthState$Processing extends AuthState with _$AuthState {
  const AuthState$Processing({
    required super.isAuthenticated,
    super.message = 'Processing',
  });
}

/// Successful
final class AuthState$Successful extends AuthState with _$AuthState {
  const AuthState$Successful({
    required super.isAuthenticated,
    super.message = 'Successful',
  });
}

/// Error
final class AuthState$Error extends AuthState with _$AuthState {
  const AuthState$Error({
    required super.isAuthenticated,
    super.message = 'An error has occurred.',
  });
}

base mixin _$AuthState on AuthState {}

/// Pattern matching for [AuthState].
typedef AuthStateMatch<R, S extends AuthState> = R Function(S state);

@immutable
abstract base class _$AuthStateBase {
  const _$AuthStateBase({required this.isAuthenticated, required this.message});

  /// isAuthenticated entity payload.
  @nonVirtual
  final AuthEntity? isAuthenticated;

  /// Message or state description.
  @nonVirtual
  final String message;

  /// Has isAuthenticated?
  bool get hasData => isAuthenticated != null;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [AuthState].
  R map<R>({
    required AuthStateMatch<R, AuthState$Idle> idle,
    required AuthStateMatch<R, AuthState$Processing> processing,
    required AuthStateMatch<R, AuthState$Successful> successful,
    required AuthStateMatch<R, AuthState$Error> error,
  }) =>
      switch (this) {
        AuthState$Idle s => idle(s),
        AuthState$Processing s => processing(s),
        AuthState$Successful s => successful(s),
        AuthState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [AuthState].
  R maybeMap<R>({
    AuthStateMatch<R, AuthState$Idle>? idle,
    AuthStateMatch<R, AuthState$Processing>? processing,
    AuthStateMatch<R, AuthState$Successful>? successful,
    AuthStateMatch<R, AuthState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [AuthState].
  R? mapOrNull<R>({
    AuthStateMatch<R, AuthState$Idle>? idle,
    AuthStateMatch<R, AuthState$Processing>? processing,
    AuthStateMatch<R, AuthState$Successful>? successful,
    AuthStateMatch<R, AuthState$Error>? error,
  }) =>
      map<R?>(
        idle: idle ?? (_) => null,
        processing: processing ?? (_) => null,
        successful: successful ?? (_) => null,
        error: error ?? (_) => null,
      );

  @override
  int get hashCode => isAuthenticated.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);
}
