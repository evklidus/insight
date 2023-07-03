import 'package:insight/features/course_previews/data/data_sources/course_previews_remote_data_source.dart';
import 'package:insight/features/course_previews/data/entities/course_preview_entity.dart';
import 'package:insight/features/course_previews/data/mappers/course_previews_mapper.dart';

abstract class CoursesPreviewRepository {
  Future<List<CoursePreviewEntity>> getCoursesPreview(String categoryTag);
}

class CoursesPreviewRepositoryImpl implements CoursesPreviewRepository {
  final CoursePreviewsRemoteDataSource remoteDataSource;

  CoursesPreviewRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<CoursePreviewEntity>> getCoursesPreview(
    String categoryTag,
  ) async {
    final courses = await remoteDataSource.getCoursePreviews(categoryTag);
    return courses.map((e) => e.toEntity()).toList();
  }
}
