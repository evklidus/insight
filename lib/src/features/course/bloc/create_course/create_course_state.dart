import 'package:meta/meta.dart';

/// {@template create_course_state_placeholder}
/// Entity placeholder for CreateCourseState
/// {@endtemplate}
typedef CreateCourseEntity = Object;

/// {@template create_course_state}
/// CreateCourseState.
/// {@endtemplate}
sealed class CreateCourseState extends _$CreateCourseStateBase {
  /// Idling state
  /// {@macro create_course_state}
  const factory CreateCourseState.idle({
    required CreateCourseEntity? data,
    String message,
  }) = CreateCourseState$Idle;

  /// Processing
  /// {@macro create_course_state}
  const factory CreateCourseState.processing({
    required CreateCourseEntity? data,
    String message,
  }) = CreateCourseState$Processing;

  /// Successful
  /// {@macro create_course_state}
  const factory CreateCourseState.successful({
    required CreateCourseEntity? data,
    String message,
  }) = CreateCourseState$Successful;

  /// An error has occurred
  /// {@macro create_course_state}
  const factory CreateCourseState.error({
    required CreateCourseEntity? data,
    String message,
  }) = CreateCourseState$Error;

  /// {@macro create_course_state}
  const CreateCourseState({required super.data, required super.message});
}

/// Idling state
final class CreateCourseState$Idle extends CreateCourseState
    with _$CreateCourseState {
  const CreateCourseState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
final class CreateCourseState$Processing extends CreateCourseState
    with _$CreateCourseState {
  const CreateCourseState$Processing(
      {required super.data, super.message = 'Processing'});
}

/// Successful
final class CreateCourseState$Successful extends CreateCourseState
    with _$CreateCourseState {
  const CreateCourseState$Successful(
      {required super.data, super.message = 'Successful'});
}

/// Error
final class CreateCourseState$Error extends CreateCourseState
    with _$CreateCourseState {
  const CreateCourseState$Error(
      {required super.data, super.message = 'An error has occurred.'});
}

base mixin _$CreateCourseState on CreateCourseState {}

/// Pattern matching for [CreateCourseState].
typedef CreateCourseStateMatch<R, S extends CreateCourseState> = R Function(
    S state);

@immutable
abstract base class _$CreateCourseStateBase {
  const _$CreateCourseStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final CreateCourseEntity? data;

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

  /// Pattern matching for [CreateCourseState].
  R map<R>({
    required CreateCourseStateMatch<R, CreateCourseState$Idle> idle,
    required CreateCourseStateMatch<R, CreateCourseState$Processing> processing,
    required CreateCourseStateMatch<R, CreateCourseState$Successful> successful,
    required CreateCourseStateMatch<R, CreateCourseState$Error> error,
  }) =>
      switch (this) {
        CreateCourseState$Idle s => idle(s),
        CreateCourseState$Processing s => processing(s),
        CreateCourseState$Successful s => successful(s),
        CreateCourseState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [CreateCourseState].
  R maybeMap<R>({
    CreateCourseStateMatch<R, CreateCourseState$Idle>? idle,
    CreateCourseStateMatch<R, CreateCourseState$Processing>? processing,
    CreateCourseStateMatch<R, CreateCourseState$Successful>? successful,
    CreateCourseStateMatch<R, CreateCourseState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [CreateCourseState].
  R? mapOrNull<R>({
    CreateCourseStateMatch<R, CreateCourseState$Idle>? idle,
    CreateCourseStateMatch<R, CreateCourseState$Processing>? processing,
    CreateCourseStateMatch<R, CreateCourseState$Successful>? successful,
    CreateCourseStateMatch<R, CreateCourseState$Error>? error,
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
