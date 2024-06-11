import 'package:insight/src/features/course_page/data/course_page_network_data_provider.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:insight/src/features/course_page/model/lesson.dart';

abstract interface class CoursePageRepository {
  Future<CoursePage> getCoursePage(String id);

  Future<void> addLesson({
    required String courseId,
    required String lessonName,
    required String videoPath,
  });

  Future<void> removeLesson({
    required String courseId,
    required Lesson lesson,
  });

  Future<void> deleteCourse({
    required String courseId,
    // Нужно чтобы удалить обложку
    required String imageUrl,
  });
}

final class CoursePageRepositoryImpl implements CoursePageRepository {
  const CoursePageRepositoryImpl({
    required CoursePageNetworkDataProvider networkDataProvider,
  }) : _networkDataProvider = networkDataProvider;

  final CoursePageNetworkDataProvider _networkDataProvider;

  @override
  getCoursePage(String id) => _networkDataProvider.getCoursePage(id);

  @override
  Future<void> deleteCourse({
    required String courseId,
    required String imageUrl,
  }) =>
      _networkDataProvider.deleteCourse(
        courseId: courseId,
        imageUrl: imageUrl,
      );

  @override
  Future<void> addLesson({
    required String courseId,
    required String lessonName,
    required String videoPath,
  }) =>
      _networkDataProvider.addLesson(
        courseId: courseId,
        lessonName: lessonName,
        videoPath: videoPath,
      );

  @override
  Future<void> removeLesson({
    required String courseId,
    required Lesson lesson,
  }) =>
      _networkDataProvider.removeLesson(
        courseId: courseId,
        lesson: lesson,
      );
}
