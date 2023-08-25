part of 'course_bloc.dart';

sealed class CourseEvent {
  const CourseEvent();

  const factory CourseEvent.fetch(String categoryTag) = _CourseEvent$Fetch;
}

final class _CourseEvent$Fetch extends CourseEvent {
  const _CourseEvent$Fetch(this.categoryTag);

  final String categoryTag;
}
