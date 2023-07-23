import 'package:insight/src/features/course_page/model/lesson.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
final class CoursePage {
  const CoursePage({
    required this.id,
    required this.imageUrl,
    required this.lessons,
  });

  factory CoursePage.fromDTO(CoursePageDTO dto) => CoursePage(
        id: dto.id,
        imageUrl: dto.imageUrl,
        lessons: dto.lessons.map(Lesson.fromDTO).toList(),
      );

  final int id;
  final String imageUrl;
  final List<Lesson> lessons;
}
