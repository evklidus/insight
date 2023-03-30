import 'package:insight/features/course_page/domain/entities/lesson_entity.dart';

class CoursePageEntity {
  final int id;
  final String imageUrl;
  final List<LessonEntity> lessons;

  CoursePageEntity({
    required this.id,
    required this.imageUrl,
    required this.lessons,
  });
}
