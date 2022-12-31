import 'package:dartz/dartz.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/features/courses_preview/domain/entities/course_preview_entity.dart';

abstract class CoursesPreviewRepository {
  Future<Either<Failure, List<CoursePreviewEntity>?>> getCoursesPreview(
    String categoryTag,
  );
}
