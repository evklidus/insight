import 'package:insight/src/features/course_page/bloc/course_enroll/course_enroll_data.dart';
import 'package:meta/meta.dart';

typedef CourseEnrollEntity = CourseEnrollData;

/// {@template course_enroll_state}
/// Состояние зачисления на курс — те же варианты, что [CoursePageState].
/// {@endtemplate}
sealed class CourseEnrollState extends _$CourseEnrollStateBase {
  /// Стабильное состояние: можно показать кнопку (если в [data] не зачислен).
  const factory CourseEnrollState.idle({
    required CourseEnrollEntity? data,
    String message,
  }) = CourseEnrollState$Idle;

  /// Проверка зачисления или отправка enroll.
  const factory CourseEnrollState.processing({
    required CourseEnrollEntity? data,
    String message,
  }) = CourseEnrollState$Processing;

  /// Пользователь в обучении по этому курсу — кнопка скрыта.
  const factory CourseEnrollState.successful({
    required CourseEnrollEntity? data,
    String message,
  }) = CourseEnrollState$Successful;

  /// Ошибка (например сеть при enroll).
  const factory CourseEnrollState.error({
    required CourseEnrollEntity? data,
    String message,
  }) = CourseEnrollState$Error;

  /// {@macro course_enroll_state}
  const CourseEnrollState({required super.data, required super.message});
}

/// Idling
final class CourseEnrollState$Idle extends CourseEnrollState
    with _$CourseEnrollState {
  const CourseEnrollState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
final class CourseEnrollState$Processing extends CourseEnrollState
    with _$CourseEnrollState {
  const CourseEnrollState$Processing({
    required super.data,
    super.message = 'Processing',
  });
}

/// Successful
final class CourseEnrollState$Successful extends CourseEnrollState
    with _$CourseEnrollState {
  const CourseEnrollState$Successful({
    required super.data,
    super.message = 'Successful',
  });
}

/// Error
final class CourseEnrollState$Error extends CourseEnrollState
    with _$CourseEnrollState {
  const CourseEnrollState$Error({
    required super.data,
    super.message = 'An error has occurred.',
  });
}

base mixin _$CourseEnrollState on CourseEnrollState {}

typedef CourseEnrollStateMatch<R, S extends CourseEnrollState> = R Function(
  S state,
);

@immutable
abstract base class _$CourseEnrollStateBase {
  const _$CourseEnrollStateBase({required this.data, required this.message});

  @nonVirtual
  final CourseEnrollEntity? data;

  @nonVirtual
  final String message;

  bool get hasData => data != null;

  bool get hasError =>
      maybeMap<bool>(orElse: () => false, error: (_) => true);

  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, processing: (_) => true);

  bool get isIdling => !isProcessing;

  /// Счётчик успешных POST enroll (для [BlocListener]).
  int get enrollSuccessGeneration => data?.enrollSuccessGeneration ?? 0;

  /// Идёт отправка enroll (кнопка «...»).
  bool get isEnrolling => data?.isEnrolling ?? false;

  /// Текст для снекбара: [CourseEnrollData.snackbarMessage] или [message] у [CourseEnrollState$Error].
  String? get snackbarMessage => map(
        idle: (s) => s.data?.snackbarMessage,
        processing: (s) => s.data?.snackbarMessage,
        successful: (s) => s.data?.snackbarMessage,
        error: (s) => s.message.isEmpty ? null : s.message,
      );

  bool get snackbarIsError => map(
        idle: (s) => s.data?.snackbarIsError ?? false,
        processing: (s) => s.data?.snackbarIsError ?? false,
        successful: (s) => s.data?.snackbarIsError ?? false,
        error: (_) => true,
      );

  R map<R>({
    required CourseEnrollStateMatch<R, CourseEnrollState$Idle> idle,
    required CourseEnrollStateMatch<R, CourseEnrollState$Processing> processing,
    required CourseEnrollStateMatch<R, CourseEnrollState$Successful> successful,
    required CourseEnrollStateMatch<R, CourseEnrollState$Error> error,
  }) =>
      switch (this) {
        CourseEnrollState$Idle s => idle(s),
        CourseEnrollState$Processing s => processing(s),
        CourseEnrollState$Successful s => successful(s),
        CourseEnrollState$Error s => error(s),
        _ => throw AssertionError(),
      };

  R maybeMap<R>({
    CourseEnrollStateMatch<R, CourseEnrollState$Idle>? idle,
    CourseEnrollStateMatch<R, CourseEnrollState$Processing>? processing,
    CourseEnrollStateMatch<R, CourseEnrollState$Successful>? successful,
    CourseEnrollStateMatch<R, CourseEnrollState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  R? mapOrNull<R>({
    CourseEnrollStateMatch<R, CourseEnrollState$Idle>? idle,
    CourseEnrollStateMatch<R, CourseEnrollState$Processing>? processing,
    CourseEnrollStateMatch<R, CourseEnrollState$Successful>? successful,
    CourseEnrollStateMatch<R, CourseEnrollState$Error>? error,
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
