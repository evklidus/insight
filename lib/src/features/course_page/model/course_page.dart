import 'package:insight/src/features/course/model/course.dart';
import 'package:insight/src/features/course_page/model/lesson.dart';
import 'package:meta/meta.dart';

@immutable
class CoursePage extends Course {
  const CoursePage({
    required super.id,
    required super.name,
    required this.description,
    required super.imageUrl,
    this.lessons,
    required super.tag,
    required super.creatorId,
    super.isClosed,
  });

  factory CoursePage.fromJson(Map json) => CoursePage(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        imageUrl: json['image_url'],
        lessons: (json['lessons'] as List?)
            ?.map((e) => Lesson.fromJson(e as Map))
            .toList(),
        tag: json['tag'],
        creatorId: json['creatorId'] ?? json['owner_id'],
        isClosed:
            json['is_private'] as bool? ?? json['is_closed'] as bool? ?? false,
      );

  factory CoursePage.fromFirestore(
    String id,
    Map<String, dynamic>? courseData,
    Map<String, dynamic>? detailData,
    String? userId,
  ) =>
      CoursePage(
        id: id,
        name: courseData!['name'],
        description: detailData!['description'],
        imageUrl: courseData['image_url'],
        lessons: detailData['lessons'] != null
            ? List.of(detailData['lessons'])
                .map(
                  (lessonData) => Lesson(
                    id: lessonData['id'] as String? ?? '',
                    name: lessonData['name'],
                    videoUrl: lessonData['video_url'],
                    completed: lessonData['completed'] as bool? ?? false,
                  ),
                )
                .toList()
            : null,
        tag: courseData['tag'],
        creatorId: courseData['owner_id'],
        isClosed: courseData['is_closed'] as bool? ?? false,
      );

  final String description;
  final List<Lesson>? lessons;

  CoursePage copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<Lesson>? lessons,
    String? tag,
    String? creatorId,
    bool? isClosed,
  }) =>
      CoursePage(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        lessons: lessons ?? this.lessons,
        tag: tag ?? this.tag,
        creatorId: creatorId ?? this.creatorId,
        isClosed: isClosed ?? this.isClosed,
      );
}
