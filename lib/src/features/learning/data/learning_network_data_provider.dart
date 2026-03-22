import 'package:dio/dio.dart';
import 'package:insight/src/features/learning/model/learning_course.dart';
import 'package:insight/src/features/profile/model/user_current_lesson.dart';
import 'package:meta/meta.dart';

@immutable
abstract interface class LearningNetworkDataProvider {
  Future<List<LearningCourse>> getMyLearning();
  Future<UserCurrentLesson?> getCurrent();
}

@immutable
final class LearningNetworkDataProviderImpl
    implements LearningNetworkDataProvider {
  const LearningNetworkDataProviderImpl(Dio client) : _client = client;

  final Dio _client;

  @override
  Future<List<LearningCourse>> getMyLearning() async {
    final response = await _client.get('/courses/my/learning');
    final list = response.data as List<dynamic>? ?? [];
    return list
        .map((e) => LearningCourse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<UserCurrentLesson?> getCurrent() async {
    final response = await _client.get('/courses/my/current');
    final data = response.data;
    if (data == null || data is! Map<String, dynamic>) return null;
    return UserCurrentLesson.fromJson(data);
  }
}

/// Заглушка для режима Firebase: учёба через REST не поддерживается.
@immutable
final class LearningFirestoreDataProviderImpl
    implements LearningNetworkDataProvider {
  const LearningFirestoreDataProviderImpl();

  @override
  Future<List<LearningCourse>> getMyLearning() async => [];

  @override
  Future<UserCurrentLesson?> getCurrent() async => null;
}
