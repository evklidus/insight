import 'package:insight/features/course_page/data/data_sources/course_page_remote_data_source.dart';
import 'package:insight/features/course_page/data/entities/course_page_entity.dart';
import 'package:insight/features/course_page/data/mappers/course_page_mapper.dart';

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
    final coursePage = await remoteDataSource.getCoursePage(id);
    return coursePage.toEntity();
  }
}
