import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:rest_client/rest_client.dart';

abstract interface class CoursePageNetworkDataProvider {
  Future<CoursePage> getCoursePage(int id);
}

final class CoursePageNetworkDataProviderImpl
    implements CoursePageNetworkDataProvider {
  const CoursePageNetworkDataProviderImpl(RestClient client) : _client = client;

  final RestClient _client;

  @override
  Future<CoursePage> getCoursePage(int id) =>
      _client.getCoursePage(id).then(CoursePage.fromDTO);
}
