import 'package:meta/meta.dart';

/// {@template profile_state_placeholder}
/// Entity placeholder for NicknameState
/// {@endtemplate}
typedef NicknameEntity = String?;

/// {@template profile_state}
/// NicknameState.
/// {@endtemplate}
sealed class NicknameState extends _$NicknameStateBase {
  /// Idling state
  /// {@macro profile_state}
  const factory NicknameState.idle({
    required NicknameEntity? data,
    String message,
  }) = NicknameState$Idle;

  /// Processing
  /// {@macro profile_state}
  const factory NicknameState.processing({
    required NicknameEntity? data,
    String message,
  }) = NicknameState$Processing;

  /// Successful
  /// {@macro profile_state}
  const factory NicknameState.successful({
    required NicknameEntity? data,
    String message,
  }) = NicknameState$Successful;

  /// An error has occurred
  /// {@macro profile_state}
  const factory NicknameState.error({
    required NicknameEntity? data,
    String message,
  }) = NicknameState$Error;

  /// {@macro profile_state}
  const NicknameState({required super.data, required super.message});
}

/// Idling state
final class NicknameState$Idle extends NicknameState with _$NicknameState {
  const NicknameState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
final class NicknameState$Processing extends NicknameState
    with _$NicknameState {
  const NicknameState$Processing({
    required super.data,
    super.message = 'Processing',
  });
}

/// Successful
final class NicknameState$Successful extends NicknameState
    with _$NicknameState {
  const NicknameState$Successful({
    required super.data,
    super.message = 'Successful',
  });
}

/// Error
final class NicknameState$Error extends NicknameState with _$NicknameState {
  const NicknameState$Error({
    required super.data,
    super.message = 'An error has occurred.',
  });
}

base mixin _$NicknameState on NicknameState {}

/// Pattern matching for [NicknameState].
typedef NicknameStateMatch<R, S extends NicknameState> = R Function(S state);

@immutable
abstract base class _$NicknameStateBase {
  const _$NicknameStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final NicknameEntity? data;

  /// Message or state description.
  @nonVirtual
  final String message;

  /// Has data?
  bool get hasData => data != null;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [NicknameState].
  R map<R>({
    required NicknameStateMatch<R, NicknameState$Idle> idle,
    required NicknameStateMatch<R, NicknameState$Processing> processing,
    required NicknameStateMatch<R, NicknameState$Successful> successful,
    required NicknameStateMatch<R, NicknameState$Error> error,
  }) =>
      switch (this) {
        NicknameState$Idle s => idle(s),
        NicknameState$Processing s => processing(s),
        NicknameState$Successful s => successful(s),
        NicknameState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [NicknameState].
  R maybeMap<R>({
    NicknameStateMatch<R, NicknameState$Idle>? idle,
    NicknameStateMatch<R, NicknameState$Processing>? processing,
    NicknameStateMatch<R, NicknameState$Successful>? successful,
    NicknameStateMatch<R, NicknameState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [NicknameState].
  R? mapOrNull<R>({
    NicknameStateMatch<R, NicknameState$Idle>? idle,
    NicknameStateMatch<R, NicknameState$Processing>? processing,
    NicknameStateMatch<R, NicknameState$Successful>? successful,
    NicknameStateMatch<R, NicknameState$Error>? error,
  }) =>
      map<R?>(
        idle: idle ?? (_) => null,
        processing: processing ?? (_) => null,
        successful: successful ?? (_) => null,
        error: error ?? (_) => null,
      );

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);
}
