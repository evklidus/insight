import 'package:insight/features/course_page/data/data_sources/course_page_remote_data_source.dart';
import 'package:insight/features/course_page/domain/entities/course_page_entity.dart';

abstract class CoursePageRepository {
  Future<CoursePageEntity> getCoursePage(int id);
}

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
