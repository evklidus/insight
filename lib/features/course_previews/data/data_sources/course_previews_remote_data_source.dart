import 'package:insight/core/http/rest_client.dart';
import 'package:insight/features/course_previews/data/models/course_preview_model.dart';

abstract class CoursePreviewsRemoteDataSource {
  Future<List<CoursePreviewModel>> getCoursePreviews(String categoryTag);
}

class CoursePreviewsRemoteDataSourceImpl
    implements CoursePreviewsRemoteDataSource {
  final RestClient client;

  CoursePreviewsRemoteDataSourceImpl(this.client);

  @override
  Future<List<CoursePreviewModel>> getCoursePreviews(
    String categoryTag,
  ) async {
    final coursePriviews =
        await client.getCoursePreviewsByCategoryTag(categoryTag);
    return coursePriviews;
  }
}
