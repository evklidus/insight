/// Business Logic Component create_course_event Events
sealed class CreateCourseEvent {
  const CreateCourseEvent();

  /// Create
  const factory CreateCourseEvent.create({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
  }) = CreateCourseEvent$Create;
}

class CreateCourseEvent$Create extends CreateCourseEvent {
  const CreateCourseEvent$Create({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.categoryTag,
  });

  final String name;
  final String description;
  final String imagePath;
  final String categoryTag;
}
