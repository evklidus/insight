part of 'course_page_bloc.dart';

sealed class CoursePageEvent {
  const CoursePageEvent();

  const factory CoursePageEvent.fetch(String id) = _CoursePageEvent$Fetch;

  const factory CoursePageEvent.delete(VoidCallback onDelete) =
      _CoursePageEvent$Delete;
}

final class _CoursePageEvent$Fetch extends CoursePageEvent {
  const _CoursePageEvent$Fetch(this.id);

  final String id;
}

final class _CoursePageEvent$Delete extends CoursePageEvent {
  const _CoursePageEvent$Delete(this.onDelete);

  final VoidCallback onDelete;
}
