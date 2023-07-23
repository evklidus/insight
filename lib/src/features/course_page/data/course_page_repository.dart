import 'package:insight/src/features/course_page/data/course_page_network_data_provider.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';

abstract interface class CoursePageRepository {
  Future<CoursePage> getCoursePage(int id);
}

final class CoursePageRepositoryImpl implements CoursePageRepository {
  const CoursePageRepositoryImpl({
    required CoursePageNetworkDataProvider networkDataProvider,
  }) : _networkDataProvider = networkDataProvider;

  final CoursePageNetworkDataProvider _networkDataProvider;

  @override
  getCoursePage(int id) => _networkDataProvider.getCoursePage(id);
}
