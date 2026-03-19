import 'package:insight/src/features/course/data/course_network_data_provider.dart';
import 'package:insight/src/features/course/model/course.dart';
import 'package:insight/src/features/course/model/course_progress.dart';
import 'package:insight/src/features/course/model/learning_course.dart';
import 'package:insight/src/features/profile/model/user_current_lesson.dart';

abstract interface class CourseRepository {
  Future<List<Course>> getCourse(String categoryTag);

  Future<List<Course>> getUserCourse();

  Future<void> createCourse({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
    bool isClosed = false,
  });

  Future<List<({String categoryName, String categoryTag})>> getCategoryTags();

  Future<void> enroll(String courseId);

  Future<void> completeLesson(String courseId, String lessonId);

  Future<List<LearningCourse>> getMyLearning();

  Future<UserCurrentLesson?> getCurrent();

  Future<CourseProgress?> getProgress(String courseId);
}

final class CourseRepositoryImpl implements CourseRepository {
  const CourseRepositoryImpl({
    required CourseNetworkDataProvider networkDataProvider,
  }) : _networkDataProvider = networkDataProvider;

  final CourseNetworkDataProvider _networkDataProvider;

  @override
  Future<List<Course>> getCourse(String categoryTag) =>
      _networkDataProvider.getCourse(categoryTag);

  @override
  Future<List<Course>> getUserCourse() => _networkDataProvider.getUserCourse();

  @override
  Future<void> createCourse({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
    bool isClosed = false,
  }) =>
      _networkDataProvider.createCourse(
        name: name,
        description: description,
        imagePath: imagePath,
        categoryTag: categoryTag,
        isClosed: isClosed,
      );

  @override
  Future<List<({String categoryName, String categoryTag})>> getCategoryTags() =>
      _networkDataProvider.getCategoryTags();

  @override
  Future<void> enroll(String courseId) => _networkDataProvider.enroll(courseId);

  @override
  Future<void> completeLesson(String courseId, String lessonId) =>
      _networkDataProvider.completeLesson(courseId, lessonId);

  @override
  Future<List<LearningCourse>> getMyLearning() =>
      _networkDataProvider.getMyLearning();

  @override
  Future<UserCurrentLesson?> getCurrent() => _networkDataProvider.getCurrent();

  @override
  Future<CourseProgress?> getProgress(String courseId) =>
      _networkDataProvider.getProgress(courseId);
}
