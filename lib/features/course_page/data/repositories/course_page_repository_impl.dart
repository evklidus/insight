import 'package:insight/features/course_page/data/datasources/course_page_remote_datasource.dart';
import 'package:insight/features/course_page/domain/repositories/course_page_repository.dart';

class CoursePageRepositoryImpl implements CoursePageRepository {
  final CoursePageRemoteDataSource remoteDataSource;

  CoursePageRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  getCoursePage(int id) async {
    return await remoteDataSource.getCoursePage(id);
  }
}
