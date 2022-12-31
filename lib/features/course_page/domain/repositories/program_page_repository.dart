import 'package:dartz/dartz.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/features/course_page/domain/entities/course_page_entity.dart';

abstract class ProgramPageRepository {
  Future<Either<Failure, CoursePageEntity?>> getCoursePage(int id);
}
