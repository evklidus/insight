import 'package:insight/src/features/course/model/course.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
abstract interface class CourseNetworkDataProvider {
  Future<List<Course>> getCourse(String categoryTag);
}

@immutable
final class CourseNetworkDataProviderImpl implements CourseNetworkDataProvider {
  const CourseNetworkDataProviderImpl(RestClient client) : _client = client;

  final RestClient _client;

  @override
  Future<List<Course>> getCourse(String categoryTag) => _client
      .getCourseByCategoryTag(categoryTag)
      .then((list) => list.map(Course.fromDTO).toList());
}
