import 'package:insight/src/features/course/data/course_network_data_provider.dart';
import 'package:insight/src/features/course/model/course.dart';

abstract interface class CourseRepository {
  Future<List<Course>> getCourse(String categoryTag);
}

final class CourseRepositoryImpl implements CourseRepository {
  const CourseRepositoryImpl({
    required CourseNetworkDataProvider networkDataProvider,
  }) : _networkDataProvider = networkDataProvider;

  final CourseNetworkDataProvider _networkDataProvider;

  @override
  Future<List<Course>> getCourse(String categoryTag) =>
      _networkDataProvider.getCourse(categoryTag);
}
