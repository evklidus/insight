import 'package:insight/features/courses_previews/data/models/course_preview_model.dart';
import 'package:insight/services/http/rest_client.dart';

abstract class CoursesPreviewRemoteDataSource {
  Future<List<CoursePreviewModel>?> getCoursesPreview(String categoryTag);
}

class CoursesPreviewRemoteDataSourceImpl
    implements CoursesPreviewRemoteDataSource {
  final RestClient client;

  CoursesPreviewRemoteDataSourceImpl(this.client);

  @override
  Future<List<CoursePreviewModel>?> getCoursesPreview(
    String categoryTag,
  ) async {
    final coursesPriview =
        await client.getCoursePreviewsByCategoryTag(categoryTag);
    return coursesPriview;
  }
}
