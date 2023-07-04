import 'package:rest_client/rest_client.dart';

abstract class CoursePageRemoteDataSource {
  Future<CoursePageDTO> getCoursePage(int id);
}

class CoursePageRemoteDataSourceImpl implements CoursePageRemoteDataSource {
  final RestClient client;

  CoursePageRemoteDataSourceImpl(this.client);

  @override
  Future<CoursePageDTO> getCoursePage(int id) async {
    final coursePage = await client.getCoursePage(id);
    return coursePage;
  }
}
