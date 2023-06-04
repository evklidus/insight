import 'package:insight/features/course_page/data/data_sources/course_page_remote_data_source.dart';
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
