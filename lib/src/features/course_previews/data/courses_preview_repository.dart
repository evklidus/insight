import 'package:insight/src/features/course_previews/data/course_previews_network_data_provider.dart';
import 'package:insight/src/features/course_previews/model/course_preview.dart';

abstract interface class CoursesPreviewRepository {
  Future<List<CoursePreview>> getCoursesPreview(String categoryTag);
}

final class CoursesPreviewRepositoryImpl implements CoursesPreviewRepository {
  const CoursesPreviewRepositoryImpl({
    required CoursePreviewsNetworkDataProvider networkDataProvider,
  }) : _networkDataProvider = networkDataProvider;

  final CoursePreviewsNetworkDataProvider _networkDataProvider;

  @override
  Future<List<CoursePreview>> getCoursesPreview(String categoryTag) =>
      _networkDataProvider.getCoursePreviews(categoryTag);
}
