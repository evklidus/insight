part of 'course_bloc.dart';

sealed class CourseEvent {
  const CourseEvent();

  const factory CourseEvent.fetch(String categoryTag) = _CourseEvent$Fetch;
  const factory CourseEvent.fetchUserCourses() = _CourseEvent$FetchUserCourses;
}

final class _CourseEvent$Fetch extends CourseEvent {
  const _CourseEvent$Fetch(this.categoryTag);

  final String categoryTag;
}

final class _CourseEvent$FetchUserCourses extends CourseEvent {
  const _CourseEvent$FetchUserCourses();
}
