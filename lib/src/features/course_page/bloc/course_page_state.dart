import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:meta/meta.dart';

/// {@template course_page_state_placeholder}
/// Entity placeholder for CoursePageState
/// {@endtemplate}
typedef CoursePageEntity = CoursePage;

/// {@template course_page_state}
/// CoursePageState.
/// {@endtemplate}
sealed class CoursePageState extends _$CoursePageStateBase {
  /// Idling state
  /// {@macro course_page_state}
  const factory CoursePageState.idle({
    required CoursePageEntity? data,
    String message,
  }) = CoursePageState$Idle;

  /// Processing
  /// {@macro course_page_state}
  const factory CoursePageState.processing({
    required CoursePageEntity? data,
    String message,
  }) = CoursePageState$Processing;

  /// Successful
  /// {@macro course_page_state}
  const factory CoursePageState.successful({
    required CoursePageEntity? data,
    String message,
  }) = CoursePageState$Successful;

  /// An error has occurred
  /// {@macro course_page_state}
  const factory CoursePageState.error({
    required CoursePageEntity? data,
    String message,
  }) = CoursePageState$Error;

  /// {@macro course_page_state}
  const CoursePageState({required super.data, required super.message});
}

/// Idling state
/// {@nodoc}
final class CoursePageState$Idle extends CoursePageState
    with _$CoursePageState {
  /// {@nodoc}
  const CoursePageState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
/// {@nodoc}
final class CoursePageState$Processing extends CoursePageState
    with _$CoursePageState {
  /// {@nodoc}
  const CoursePageState$Processing({
    required super.data,
    super.message = 'Processing',
  });
}

/// Successful
/// {@nodoc}
final class CoursePageState$Successful extends CoursePageState
    with _$CoursePageState {
  /// {@nodoc}
  const CoursePageState$Successful({
    required super.data,
    super.message = 'Successful',
  });
}

/// Error
/// {@nodoc}
final class CoursePageState$Error extends CoursePageState
    with _$CoursePageState {
  /// {@nodoc}
  const CoursePageState$Error({
    required super.data,
    super.message = 'An error has occurred.',
  });
}

/// {@nodoc}
base mixin _$CoursePageState on CoursePageState {}

/// Pattern matching for [CoursePageState].
typedef CoursePageStateMatch<R, S extends CoursePageState> = R Function(
  S state,
);

/// {@nodoc}
@immutable
abstract base class _$CoursePageStateBase {
  /// {@nodoc}
  const _$CoursePageStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final CoursePageEntity? data;

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

  /// Pattern matching for [CoursePageState].
  R map<R>({
    required CoursePageStateMatch<R, CoursePageState$Idle> idle,
    required CoursePageStateMatch<R, CoursePageState$Processing> processing,
    required CoursePageStateMatch<R, CoursePageState$Successful> successful,
    required CoursePageStateMatch<R, CoursePageState$Error> error,
  }) =>
      switch (this) {
        CoursePageState$Idle s => idle(s),
        CoursePageState$Processing s => processing(s),
        CoursePageState$Successful s => successful(s),
        CoursePageState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [CoursePageState].
  R maybeMap<R>({
    CoursePageStateMatch<R, CoursePageState$Idle>? idle,
    CoursePageStateMatch<R, CoursePageState$Processing>? processing,
    CoursePageStateMatch<R, CoursePageState$Successful>? successful,
    CoursePageStateMatch<R, CoursePageState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [CoursePageState].
  R? mapOrNull<R>({
    CoursePageStateMatch<R, CoursePageState$Idle>? idle,
    CoursePageStateMatch<R, CoursePageState$Processing>? processing,
    CoursePageStateMatch<R, CoursePageState$Successful>? successful,
    CoursePageStateMatch<R, CoursePageState$Error>? error,
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
