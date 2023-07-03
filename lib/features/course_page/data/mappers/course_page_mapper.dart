import 'package:insight/features/course_page/data/entities/course_page_entity.dart';
import 'package:insight/features/course_page/data/mappers/lesson_mapper.dart';
import 'package:rest_client/rest_client.dart';

extension CoursePageMapper on CoursePageDTO {
  CoursePageEntity toEntity() {
    final lessonEntities = lessons.map((e) => e.toEntity()).toList();

    return CoursePageEntity(
      id: id,
      imageUrl: imageUrl,
      lessons: lessonEntities,
    );
  }
}
