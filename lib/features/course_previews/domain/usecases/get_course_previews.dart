import 'package:insight/core/usecases/usecase.dart';
import 'package:insight/features/course_previews/domain/entities/course_preview_entity.dart';
import 'package:insight/features/course_previews/domain/repositories/courses_preview_repository.dart';

class GetCoursePreviews
    extends UseCaseWithParams<List<CoursePreviewEntity>, CoursePreviewsParams> {
  final CoursesPreviewRepository coursesPreviewRepository;

  GetCoursePreviews(this.coursesPreviewRepository);

  @override
  call(CoursePreviewsParams params) async {
    return await coursesPreviewRepository.getCoursesPreview(params.categoryTag);
  }
}

class CoursePreviewsParams {
  final String categoryTag;
  CoursePreviewsParams({required this.categoryTag});
}
