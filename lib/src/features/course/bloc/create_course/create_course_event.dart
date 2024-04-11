import 'package:flutter/foundation.dart';

/// Business Logic Component create_course_event Events
sealed class CreateCourseEvent {
  const CreateCourseEvent();

  /// Fetch tags
  const factory CreateCourseEvent.fetchTags() = CreateCourseEvent$FetchTags;

  /// Create
  const factory CreateCourseEvent.create({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
    VoidCallback? onCreateCallback,
  }) = CreateCourseEvent$Create;
}

class CreateCourseEvent$FetchTags extends CreateCourseEvent {
  const CreateCourseEvent$FetchTags();
}

class CreateCourseEvent$Create extends CreateCourseEvent {
  const CreateCourseEvent$Create({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.categoryTag,
    this.onCreateCallback,
  });

  final String name;
  final String description;
  final String imagePath;
  final String categoryTag;
  final VoidCallback? onCreateCallback;
}
