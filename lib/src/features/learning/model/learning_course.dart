import 'package:meta/meta.dart';

import 'package:insight/src/features/course/model/course.dart';

/// Элемент GET /courses/my/learning
@immutable
final class LearningCourse {
  const LearningCourse({
    required this.course,
    required this.status,
    required this.watchedCount,
    required this.totalLessons,
    this.lastLessonName,
    this.completedAt,
  });

  factory LearningCourse.fromJson(Map<String, dynamic> json) {
    final course = json['course'];
    return LearningCourse(
      course: course != null
          ? Course.fromJson(course as Map<String, dynamic>)
          : throw const FormatException('course required'),
      status: json['status'] as String,
      watchedCount: json['watched_count'] as int? ?? 0,
      totalLessons: json['total_lessons'] as int? ?? 0,
      lastLessonName: json['last_lesson_name'] as String?,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
    );
  }

  final Course course;
  final String status;
  final int watchedCount;
  final int totalLessons;
  final String? lastLessonName;
  final DateTime? completedAt;

  bool get isNotStarted => status == 'not_started';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';

  String get statusLabel => switch (status) {
        'not_started' => 'Не начат',
        'in_progress' => 'В процессе',
        'completed' => 'Завершён',
        _ => status,
      };
}
