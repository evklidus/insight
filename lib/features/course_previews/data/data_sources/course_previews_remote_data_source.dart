import 'package:rest_client/rest_client.dart';

abstract class CoursePreviewsRemoteDataSource {
  Future<List<CoursePreviewDTO>> getCoursePreviews(String categoryTag);
}

class CoursePreviewsRemoteDataSourceImpl
    implements CoursePreviewsRemoteDataSource {
  final RestClient client;

  CoursePreviewsRemoteDataSourceImpl(this.client);

  @override
  Future<List<CoursePreviewDTO>> getCoursePreviews(
    String categoryTag,
  ) async {
    final coursePriviews =
        await client.getCoursePreviewsByCategoryTag(categoryTag);
    return coursePriviews;
  }
}
