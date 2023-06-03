import 'package:insight/features/course_page/data/models/course_page_model.dart';
import 'package:insight/core/http/rest_client.dart';

abstract class CoursePageRemoteDataSource {
  Future<CoursePageModel> getCoursePage(int id);
}

class CoursePageRemoteDataSourceImpl implements CoursePageRemoteDataSource {
  final RestClient client;

  CoursePageRemoteDataSourceImpl(this.client);

  @override
  Future<CoursePageModel> getCoursePage(int id) async {
    final coursePage = await client.getCoursePage(id);
    return coursePage;
  }
}
