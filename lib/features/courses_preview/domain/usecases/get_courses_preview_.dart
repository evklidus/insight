import 'package:insight/core/usecases/usecase.dart';
import 'package:insight/features/courses_preview/domain/entities/course_preview_entity.dart';
import 'package:insight/features/courses_preview/domain/repositories/courses_preview_repository.dart';

class GetCoursesPreview extends UseCaseWithParams<List<CoursePreviewEntity>?,
    CoursesPreviewParams> {
  final CoursesPreviewRepository coursesPreviewRepository;

  GetCoursesPreview(this.coursesPreviewRepository);

  @override
  call(CoursesPreviewParams params) async {
    return await coursesPreviewRepository.getCoursesPreview(params.categoryTag);
  }
}

class CoursesPreviewParams {
  final String categoryTag;
  CoursesPreviewParams({required this.categoryTag});
}
