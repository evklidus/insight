import 'package:meta/meta.dart';

import 'package:insight/src/features/learning/model/learning_course.dart';
import 'package:insight/src/features/profile/model/user_current_lesson.dart';

/// {@template learning_state}
/// Состояние таба «Учёба» в стиле [CoursePageState].
/// {@endtemplate}
sealed class LearningState extends _$LearningStateBase {
  /// Начальное / после [LearningEvent.clear].
  const factory LearningState.idle({
    UserCurrentLesson? current,
    List<LearningCourse> learning,
    String message,
  }) = LearningState$Idle;

  /// Загрузка текущего урока или списка «моё обучение».
  const factory LearningState.processing({
    required UserCurrentLesson? current,
    required List<LearningCourse> learning,
    String message,
  }) = LearningState$Processing;

  /// Успешные данные.
  const factory LearningState.successful({
    required UserCurrentLesson? current,
    required List<LearningCourse> learning,
    String message,
  }) = LearningState$Successful;

  /// Ошибка сети/парсинга; сохраняем последние известные данные.
  const factory LearningState.error({
    required UserCurrentLesson? current,
    required List<LearningCourse> learning,
    required String message,
  }) = LearningState$Error;

  /// {@macro learning_state}
  const LearningState({
    required super.current,
    required super.learning,
    required super.message,
  });
}

/// Начальное / после clear.
final class LearningState$Idle extends LearningState with _$LearningState {
  const LearningState$Idle({
    super.current,
    super.learning = const [],
    super.message = '',
  });
}

/// Загрузка.
final class LearningState$Processing extends LearningState
    with _$LearningState {
  const LearningState$Processing({
    required super.current,
    required super.learning,
    super.message = '',
  });
}

/// Успех.
final class LearningState$Successful extends LearningState
    with _$LearningState {
  const LearningState$Successful({
    required super.current,
    required super.learning,
    super.message = '',
  });
}

/// Ошибка.
final class LearningState$Error extends LearningState with _$LearningState {
  const LearningState$Error({
    required super.current,
    required super.learning,
    required super.message,
  });
}

base mixin _$LearningState on LearningState {}

/// Pattern matching for [LearningState].
typedef LearningStateMatch<R, S extends LearningState> = R Function(S state);

@immutable
abstract base class _$LearningStateBase {
  const _$LearningStateBase({
    required this.current,
    required this.learning,
    required this.message,
  });

  /// Текущий урок (с сервера).
  @nonVirtual
  final UserCurrentLesson? current;

  /// Список курсов в обучении.
  @nonVirtual
  final List<LearningCourse> learning;

  /// Текст ошибки; пустая строка, если не [LearningState$Error].
  @nonVirtual
  final String message;

  bool get hasData => current != null || learning.isNotEmpty;

  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, processing: (_) => true);

  R map<R>({
    required LearningStateMatch<R, LearningState$Idle> idle,
    required LearningStateMatch<R, LearningState$Processing> processing,
    required LearningStateMatch<R, LearningState$Successful> successful,
    required LearningStateMatch<R, LearningState$Error> error,
  }) =>
      switch (this) {
        LearningState$Idle s => idle(s),
        LearningState$Processing s => processing(s),
        LearningState$Successful s => successful(s),
        LearningState$Error s => error(s),
        _ => throw AssertionError(),
      };

  R maybeMap<R>({
    LearningStateMatch<R, LearningState$Idle>? idle,
    LearningStateMatch<R, LearningState$Processing>? processing,
    LearningStateMatch<R, LearningState$Successful>? successful,
    LearningStateMatch<R, LearningState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  R? mapOrNull<R>({
    LearningStateMatch<R, LearningState$Idle>? idle,
    LearningStateMatch<R, LearningState$Processing>? processing,
    LearningStateMatch<R, LearningState$Successful>? successful,
    LearningStateMatch<R, LearningState$Error>? error,
  }) =>
      map<R?>(
        idle: idle ?? (_) => null,
        processing: processing ?? (_) => null,
        successful: successful ?? (_) => null,
        error: error ?? (_) => null,
      );

  @override
  int get hashCode => Object.hash(current, learning, message);

  @override
  bool operator ==(Object other) => identical(this, other);
}
