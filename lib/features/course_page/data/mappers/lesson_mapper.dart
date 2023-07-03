import 'package:insight/features/course_page/data/entities/lesson_entity.dart';
import 'package:rest_client/rest_client.dart';

extension LessonMapper on LessonDTO {
  LessonEntity toEntity() {
    return LessonEntity(
      name: name,
      videoUrl: videoUrl,
    );
  }
}
