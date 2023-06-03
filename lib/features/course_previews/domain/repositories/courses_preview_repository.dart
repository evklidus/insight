import 'package:insight/features/course_previews/domain/entities/course_preview_entity.dart';

abstract class CoursesPreviewRepository {
  Future<List<CoursePreviewEntity>> getCoursesPreview(String categoryTag);
}
