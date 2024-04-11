import 'package:insight/src/features/course/data/course_network_data_provider.dart';
import 'package:insight/src/features/course/model/course.dart';

abstract interface class CourseRepository {
  Future<List<Course>> getCourse(String categoryTag);

  Future<void> createCourse({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
  });

  Future<List<({String categoryName, String categoryTag})>> getCategoryTags();
}

final class CourseRepositoryImpl implements CourseRepository {
  const CourseRepositoryImpl({
    required CourseNetworkDataProvider networkDataProvider,
  }) : _networkDataProvider = networkDataProvider;

  final CourseNetworkDataProvider _networkDataProvider;

  @override
  Future<List<Course>> getCourse(String categoryTag) =>
      _networkDataProvider.getCourse(categoryTag);

  @override
  Future<void> createCourse({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
  }) =>
      _networkDataProvider.createCourse(
        name: name,
        description: description,
        imagePath: imagePath,
        categoryTag: categoryTag,
      );

  @override
  Future<List<({String categoryName, String categoryTag})>> getCategoryTags() =>
      _networkDataProvider.getCategoryTags();
}
