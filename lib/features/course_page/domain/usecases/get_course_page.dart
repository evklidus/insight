import 'package:insight/core/usecases/usecase.dart';
import 'package:insight/features/course_page/domain/entities/course_page_entity.dart';
import 'package:insight/features/course_page/domain/repositories/course_page_repository.dart';

class GetCoursePage
    extends UseCaseWithParams<CoursePageEntity?, CoursePageParams> {
  final CoursePageRepository repository;

  GetCoursePage(this.repository);

  @override
  call(CoursePageParams params) {
    final coursePage = repository.getCoursePage(params.id);
    return coursePage;
  }
}

class CoursePageParams {
  final int id;
  CoursePageParams({required this.id});
}
