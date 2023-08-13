import 'package:insight/src/features/course/model/course.dart';
import 'package:meta/meta.dart';

/// {@template course_state_placeholder}
/// Entity placeholder for CourseState
/// {@endtemplate}
typedef CourseEntity = List<Course>;

/// {@template course_state}
/// CourseState.
/// {@endtemplate}
sealed class CourseState extends _$CourseStateBase {
  /// Idling state
  /// {@macro course_state}
  const factory CourseState.idle({
    required CourseEntity? data,
    String message,
  }) = CourseState$Idle;

  /// Processing
  /// {@macro course_state}
  const factory CourseState.processing({
    required CourseEntity? data,
    String message,
  }) = CourseState$Processing;

  /// Successful
  /// {@macro course_state}
  const factory CourseState.successful({
    required CourseEntity? data,
    String message,
  }) = CourseState$Successful;

  /// An error has occurred
  /// {@macro course_state}
  const factory CourseState.error({
    required CourseEntity? data,
    String message,
  }) = CourseState$Error;

  /// {@macro course_state}
  const CourseState({required super.data, required super.message});
}

/// Idling state
/// {@nodoc}
final class CourseState$Idle extends CourseState with _$CourseState {
  /// {@nodoc}
  const CourseState$Idle({
    required super.data,
    super.message = 'Idling',
  });
}

/// Processing
/// {@nodoc}
final class CourseState$Processing extends CourseState with _$CourseState {
  /// {@nodoc}
  const CourseState$Processing({
    required super.data,
    super.message = 'Processing',
  });
}

/// Successful
/// {@nodoc}
final class CourseState$Successful extends CourseState with _$CourseState {
  /// {@nodoc}
  const CourseState$Successful({
    required super.data,
    super.message = 'Successful',
  });
}

/// Error
/// {@nodoc}
final class CourseState$Error extends CourseState with _$CourseState {
  /// {@nodoc}
  const CourseState$Error({
    required super.data,
    super.message = 'An error has occurred.',
  });
}

/// {@nodoc}
base mixin _$CourseState on CourseState {}

/// Pattern matching for [CourseState].
typedef CourseStateMatch<R, S extends CourseState> = R Function(
  S state,
);

/// {@nodoc}
@immutable
abstract base class _$CourseStateBase {
  /// {@nodoc}
  const _$CourseStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final CourseEntity? data;

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

  /// Pattern matching for [CourseState].
  R map<R>({
    required CourseStateMatch<R, CourseState$Idle> idle,
    required CourseStateMatch<R, CourseState$Processing> processing,
    required CourseStateMatch<R, CourseState$Successful> successful,
    required CourseStateMatch<R, CourseState$Error> error,
  }) =>
      switch (this) {
        CourseState$Idle s => idle(s),
        CourseState$Processing s => processing(s),
        CourseState$Successful s => successful(s),
        CourseState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [CourseState].
  R maybeMap<R>({
    CourseStateMatch<R, CourseState$Idle>? idle,
    CourseStateMatch<R, CourseState$Processing>? processing,
    CourseStateMatch<R, CourseState$Successful>? successful,
    CourseStateMatch<R, CourseState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [CourseState].
  R? mapOrNull<R>({
    CourseStateMatch<R, CourseState$Idle>? idle,
    CourseStateMatch<R, CourseState$Processing>? processing,
    CourseStateMatch<R, CourseState$Successful>? successful,
    CourseStateMatch<R, CourseState$Error>? error,
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
