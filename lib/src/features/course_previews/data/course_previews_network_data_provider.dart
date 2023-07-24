import 'package:insight/src/features/course_previews/model/course_preview.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
abstract interface class CoursePreviewsNetworkDataProvider {
  Future<List<CoursePreview>> getCoursePreviews(String categoryTag);
}

@immutable
final class CoursePreviewsNetworkDataProviderImpl
    implements CoursePreviewsNetworkDataProvider {
  const CoursePreviewsNetworkDataProviderImpl(RestClient client)
      : _client = client;

  final RestClient _client;

  @override
  Future<List<CoursePreview>> getCoursePreviews(String categoryTag) => _client
      .getCoursePreviewsByCategoryTag(categoryTag)
      .then((list) => list.map(CoursePreview.fromDTO).toList());
}
