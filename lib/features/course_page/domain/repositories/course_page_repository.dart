import 'package:dartz/dartz.dart';
import 'package:insight/common/models/failure.dart';
import 'package:insight/features/course_page/domain/entities/course_page_entity.dart';

abstract class CoursePageRepository {
  Future<Either<Failure, CoursePageEntity?>> getCoursePage(int id);
}
