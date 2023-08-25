part of 'course_page_bloc.dart';

sealed class CoursePageEvent {
  const CoursePageEvent();

  const factory CoursePageEvent.fetch(String id) = _CoursePageEvent$Fetch;
}

final class _CoursePageEvent$Fetch extends CoursePageEvent {
  const _CoursePageEvent$Fetch(this.id);

  final String id;
}
