import 'package:insight/features/course_previews/data/datasources/course_previews_remote_datasource.dart';
import 'package:insight/features/course_previews/domain/entities/course_preview_entity.dart';
import 'package:insight/features/course_previews/domain/repositories/courses_preview_repository.dart';

class CoursesPreviewRepositoryImpl implements CoursesPreviewRepository {
  final CoursePreviewsRemoteDataSource remoteDataSource;

  CoursesPreviewRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<CoursePreviewEntity>> getCoursesPreview(
    String categoryTag,
  ) async {
    return await remoteDataSource.getCoursePreviews(categoryTag);
  }
}
