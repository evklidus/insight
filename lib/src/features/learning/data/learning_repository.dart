import 'package:insight/src/features/learning/data/learning_network_data_provider.dart';
import 'package:insight/src/features/learning/model/learning_course.dart';
import 'package:insight/src/features/profile/model/user_current_lesson.dart';

abstract interface class LearningRepository {
  Future<List<LearningCourse>> getMyLearning();

  Future<UserCurrentLesson?> getCurrent();
}

final class LearningRepositoryImpl implements LearningRepository {
  const LearningRepositoryImpl({
    required LearningNetworkDataProvider networkDataProvider,
  }) : _networkDataProvider = networkDataProvider;

  final LearningNetworkDataProvider _networkDataProvider;

  @override
  Future<List<LearningCourse>> getMyLearning() =>
      _networkDataProvider.getMyLearning();

  @override
  Future<UserCurrentLesson?> getCurrent() => _networkDataProvider.getCurrent();
}
