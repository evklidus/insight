import 'package:dartz/dartz.dart';
import 'package:insight/common/models/failure.dart';
import 'package:insight/features/course_previews/domain/entities/course_preview_entity.dart';

abstract class CoursesPreviewRepository {
  Future<Either<Failure, List<CoursePreviewEntity>>> getCoursesPreview(
    String categoryTag,
  );
}
