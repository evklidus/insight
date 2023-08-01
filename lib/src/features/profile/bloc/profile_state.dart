import 'package:insight/src/features/profile/model/user.dart';
import 'package:meta/meta.dart';

/// {@template profile_state_placeholder}
/// Entity placeholder for ProfileState
/// {@endtemplate}
typedef ProfileEntity = User;

/// {@template profile_state}
/// ProfileState.
/// {@endtemplate}
sealed class ProfileState extends _$ProfileStateBase {
  /// Idling state
  /// {@macro profile_state}
  const factory ProfileState.idle({
    required ProfileEntity? data,
    String message,
  }) = ProfileState$Idle;

  /// Processing
  /// {@macro profile_state}
  const factory ProfileState.processing({
    required ProfileEntity? data,
    String message,
  }) = ProfileState$Processing;

  /// Successful
  /// {@macro profile_state}
  const factory ProfileState.successful({
    required ProfileEntity? data,
    String message,
  }) = ProfileState$Successful;

  /// An error has occurred
  /// {@macro profile_state}
  const factory ProfileState.error({
    required ProfileEntity? data,
    String message,
  }) = ProfileState$Error;

  /// {@macro profile_state}
  const ProfileState({required super.data, required super.message});
}

/// Idling state
/// {@nodoc}
final class ProfileState$Idle extends ProfileState with _$ProfileState {
  /// {@nodoc}
  const ProfileState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
/// {@nodoc}
final class ProfileState$Processing extends ProfileState with _$ProfileState {
  /// {@nodoc}
  const ProfileState$Processing({
    required super.data,
    super.message = 'Processing',
  });
}

/// Successful
/// {@nodoc}
final class ProfileState$Successful extends ProfileState with _$ProfileState {
  /// {@nodoc}
  const ProfileState$Successful({
    required super.data,
    super.message = 'Successful',
  });
}

/// Error
/// {@nodoc}
final class ProfileState$Error extends ProfileState with _$ProfileState {
  /// {@nodoc}
  const ProfileState$Error({
    required super.data,
    super.message = 'An error has occurred.',
  });
}

/// {@nodoc}
base mixin _$ProfileState on ProfileState {}

/// Pattern matching for [ProfileState].
typedef ProfileStateMatch<R, S extends ProfileState> = R Function(S state);

/// {@nodoc}
@immutable
abstract base class _$ProfileStateBase {
  /// {@nodoc}
  const _$ProfileStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final ProfileEntity? data;

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

  /// Pattern matching for [ProfileState].
  R map<R>({
    required ProfileStateMatch<R, ProfileState$Idle> idle,
    required ProfileStateMatch<R, ProfileState$Processing> processing,
    required ProfileStateMatch<R, ProfileState$Successful> successful,
    required ProfileStateMatch<R, ProfileState$Error> error,
  }) =>
      switch (this) {
        ProfileState$Idle s => idle(s),
        ProfileState$Processing s => processing(s),
        ProfileState$Successful s => successful(s),
        ProfileState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [ProfileState].
  R maybeMap<R>({
    ProfileStateMatch<R, ProfileState$Idle>? idle,
    ProfileStateMatch<R, ProfileState$Processing>? processing,
    ProfileStateMatch<R, ProfileState$Successful>? successful,
    ProfileStateMatch<R, ProfileState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [ProfileState].
  R? mapOrNull<R>({
    ProfileStateMatch<R, ProfileState$Idle>? idle,
    ProfileStateMatch<R, ProfileState$Processing>? processing,
    ProfileStateMatch<R, ProfileState$Successful>? successful,
    ProfileStateMatch<R, ProfileState$Error>? error,
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
