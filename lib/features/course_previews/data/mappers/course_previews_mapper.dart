import 'package:insight/features/course_previews/data/entities/course_preview_entity.dart';
import 'package:rest_client/rest_client.dart';

extension CoursePreviewsMapper on CoursePreviewDTO {
  CoursePreviewEntity toEntity() {
    return CoursePreviewEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      tag: tag,
    );
  }
}
