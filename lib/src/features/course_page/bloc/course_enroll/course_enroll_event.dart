part of 'course_enroll_bloc.dart';

sealed class CourseEnrollEvent {
  const CourseEnrollEvent();

  const factory CourseEnrollEvent.check() = _CourseEnrollEvent$Check;

  const factory CourseEnrollEvent.enroll() = _CourseEnrollEvent$Enroll;

  const factory CourseEnrollEvent.acknowledgeSnackbar() =
      _CourseEnrollEvent$AcknowledgeSnackbar;
}

final class _CourseEnrollEvent$Check extends CourseEnrollEvent {
  const _CourseEnrollEvent$Check();
}

final class _CourseEnrollEvent$Enroll extends CourseEnrollEvent {
  const _CourseEnrollEvent$Enroll();
}

final class _CourseEnrollEvent$AcknowledgeSnackbar extends CourseEnrollEvent {
  const _CourseEnrollEvent$AcknowledgeSnackbar();
}
