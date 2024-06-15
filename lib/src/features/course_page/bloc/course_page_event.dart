part of 'course_page_bloc.dart';

sealed class CoursePageEvent {
  const CoursePageEvent();

  const factory CoursePageEvent.fetch(String id) = _CoursePageEvent$Fetch;

  const factory CoursePageEvent.addLesson({
    required String name,
    required String videoPath,
    required VoidCallback onAdd,
  }) = _CoursePageEvent$AddLesson;

  const factory CoursePageEvent.removeLesson({
    required Lesson lesson,
    required VoidCallback onRemove,
  }) = _CoursePageEvent$RemoveLesson;

  const factory CoursePageEvent.delete(VoidCallback onDelete) =
      _CoursePageEvent$Delete;
}

final class _CoursePageEvent$Fetch extends CoursePageEvent {
  const _CoursePageEvent$Fetch(this.id);

  final String id;
}

final class _CoursePageEvent$AddLesson extends CoursePageEvent {
  const _CoursePageEvent$AddLesson({
    required this.name,
    required this.videoPath,
    required this.onAdd,
  });

  final String name;
  final String videoPath;
  final VoidCallback onAdd;
}

final class _CoursePageEvent$RemoveLesson extends CoursePageEvent {
  const _CoursePageEvent$RemoveLesson({
    required this.lesson,
    required this.onRemove,
  });

  final Lesson lesson;
  final VoidCallback onRemove;
}

final class _CoursePageEvent$Delete extends CoursePageEvent {
  const _CoursePageEvent$Delete(this.onDelete);

  final VoidCallback onDelete;
}
