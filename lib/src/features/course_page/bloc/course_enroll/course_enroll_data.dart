import 'package:meta/meta.dart';

/// Полезная нагрузка [CourseEnrollState] (аналог сущности курса в [CoursePageState]).
@immutable
final class CourseEnrollData {
  const CourseEnrollData({
    this.enrollSuccessGeneration = 0,
    this.isEnrolling = false,
    this.snackbarMessage,
    this.snackbarIsError = false,
    this.isUserEnrolled = false,
  });

  /// Счётчик успешных POST enroll (для слушателей).
  final int enrollSuccessGeneration;

  /// Идёт запись на курс (кнопка в режиме загрузки).
  final bool isEnrolling;

  final String? snackbarMessage;

  final bool snackbarIsError;

  /// true — пользователь уже в GET /courses/my/learning (кнопка скрыта).
  final bool isUserEnrolled;
}
