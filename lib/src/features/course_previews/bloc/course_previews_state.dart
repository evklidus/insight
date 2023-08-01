import 'package:insight/src/features/course_previews/model/course_preview.dart';
import 'package:meta/meta.dart';

/// {@template course_previews_state_placeholder}
/// Entity placeholder for CoursePreviewsState
/// {@endtemplate}
typedef CoursePreviewsEntity = List<CoursePreview>;

/// {@template course_previews_state}
/// CoursePreviewsState.
/// {@endtemplate}
sealed class CoursePreviewsState extends _$CoursePreviewsStateBase {
  /// Idling state
  /// {@macro course_previews_state}
  const factory CoursePreviewsState.idle({
    required CoursePreviewsEntity? data,
    String message,
  }) = CoursePreviewsState$Idle;

  /// Processing
  /// {@macro course_previews_state}
  const factory CoursePreviewsState.processing({
    required CoursePreviewsEntity? data,
    String message,
  }) = CoursePreviewsState$Processing;

  /// Successful
  /// {@macro course_previews_state}
  const factory CoursePreviewsState.successful({
    required CoursePreviewsEntity? data,
    String message,
  }) = CoursePreviewsState$Successful;

  /// An error has occurred
  /// {@macro course_previews_state}
  const factory CoursePreviewsState.error({
    required CoursePreviewsEntity? data,
    String message,
  }) = CoursePreviewsState$Error;

  /// {@macro course_previews_state}
  const CoursePreviewsState({required super.data, required super.message});
}

/// Idling state
/// {@nodoc}
final class CoursePreviewsState$Idle extends CoursePreviewsState
    with _$CoursePreviewsState {
  /// {@nodoc}
  const CoursePreviewsState$Idle({
    required super.data,
    super.message = 'Idling',
  });
}

/// Processing
/// {@nodoc}
final class CoursePreviewsState$Processing extends CoursePreviewsState
    with _$CoursePreviewsState {
  /// {@nodoc}
  const CoursePreviewsState$Processing({
    required super.data,
    super.message = 'Processing',
  });
}

/// Successful
/// {@nodoc}
final class CoursePreviewsState$Successful extends CoursePreviewsState
    with _$CoursePreviewsState {
  /// {@nodoc}
  const CoursePreviewsState$Successful({
    required super.data,
    super.message = 'Successful',
  });
}

/// Error
/// {@nodoc}
final class CoursePreviewsState$Error extends CoursePreviewsState
    with _$CoursePreviewsState {
  /// {@nodoc}
  const CoursePreviewsState$Error({
    required super.data,
    super.message = 'An error has occurred.',
  });
}

/// {@nodoc}
base mixin _$CoursePreviewsState on CoursePreviewsState {}

/// Pattern matching for [CoursePreviewsState].
typedef CoursePreviewsStateMatch<R, S extends CoursePreviewsState> = R Function(
  S state,
);

/// {@nodoc}
@immutable
abstract base class _$CoursePreviewsStateBase {
  /// {@nodoc}
  const _$CoursePreviewsStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final CoursePreviewsEntity? data;

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

  /// Pattern matching for [CoursePreviewsState].
  R map<R>({
    required CoursePreviewsStateMatch<R, CoursePreviewsState$Idle> idle,
    required CoursePreviewsStateMatch<R, CoursePreviewsState$Processing>
        processing,
    required CoursePreviewsStateMatch<R, CoursePreviewsState$Successful>
        successful,
    required CoursePreviewsStateMatch<R, CoursePreviewsState$Error> error,
  }) =>
      switch (this) {
        CoursePreviewsState$Idle s => idle(s),
        CoursePreviewsState$Processing s => processing(s),
        CoursePreviewsState$Successful s => successful(s),
        CoursePreviewsState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [CoursePreviewsState].
  R maybeMap<R>({
    CoursePreviewsStateMatch<R, CoursePreviewsState$Idle>? idle,
    CoursePreviewsStateMatch<R, CoursePreviewsState$Processing>? processing,
    CoursePreviewsStateMatch<R, CoursePreviewsState$Successful>? successful,
    CoursePreviewsStateMatch<R, CoursePreviewsState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [CoursePreviewsState].
  R? mapOrNull<R>({
    CoursePreviewsStateMatch<R, CoursePreviewsState$Idle>? idle,
    CoursePreviewsStateMatch<R, CoursePreviewsState$Processing>? processing,
    CoursePreviewsStateMatch<R, CoursePreviewsState$Successful>? successful,
    CoursePreviewsStateMatch<R, CoursePreviewsState$Error>? error,
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
