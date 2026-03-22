part of 'learning_bloc.dart';

sealed class LearningEvent {
  const LearningEvent();

  const factory LearningEvent.fetchCurrent() = _LearningEvent$FetchCurrent;

  const factory LearningEvent.fetchLearning() = _LearningEvent$FetchLearning;

  const factory LearningEvent.clear() = _LearningEvent$Clear;

  const factory LearningEvent.completeLesson({
    required String courseId,
    required String lessonId,
  }) = _LearningEvent$CompleteLesson;

  const factory LearningEvent.enroll(String courseId) = _LearningEvent$Enroll;
}

final class _LearningEvent$FetchCurrent extends LearningEvent {
  const _LearningEvent$FetchCurrent();
}

final class _LearningEvent$FetchLearning extends LearningEvent {
  const _LearningEvent$FetchLearning();
}

final class _LearningEvent$Clear extends LearningEvent {
  const _LearningEvent$Clear();
}

final class _LearningEvent$CompleteLesson extends LearningEvent {
  const _LearningEvent$CompleteLesson({
    required this.courseId,
    required this.lessonId,
  });

  final String courseId;
  final String lessonId;
}

final class _LearningEvent$Enroll extends LearningEvent {
  const _LearningEvent$Enroll(this.courseId);

  final String courseId;
}
