import 'package:meta/meta.dart';

import 'package:insight/src/features/course/model/learning_course.dart';
import 'package:insight/src/features/profile/model/user_current_lesson.dart';

@immutable
final class LearningState {
  const LearningState({
    this.current,
    this.learning = const [],
    this.isProcessing = false,
    this.hasError = false,
    this.message,
  });

  final UserCurrentLesson? current;
  final List<LearningCourse> learning;
  final bool isProcessing;
  final bool hasError;
  final String? message;

  bool get hasData => current != null || learning.isNotEmpty;

  LearningState copyWith({
    UserCurrentLesson? current,
    List<LearningCourse>? learning,
    bool? isProcessing,
    bool? hasError,
    String? message,
  }) =>
      LearningState(
        current: current ?? this.current,
        learning: learning ?? this.learning,
        isProcessing: isProcessing ?? this.isProcessing,
        hasError: hasError ?? this.hasError,
        message: message ?? this.message,
      );
}
