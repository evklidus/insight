import 'package:insight/features/course_page/domain/entities/course_page_entity.dart';

abstract class CoursePageRepository {
  Future<CoursePageEntity> getCoursePage(int id);
}
