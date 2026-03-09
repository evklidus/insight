import 'package:meta/meta.dart';

/// Ответ GET /courses/:id/progress
@immutable
final class CourseProgress {
  const CourseProgress({
    required this.status,
    required this.watchedLessons,
    required this.lastLessonName,
    this.completedAt,
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) => CourseProgress(
        status: json['status'] as String? ?? 'not_started',
        watchedLessons: (json['watched_lessons'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        lastLessonName: json['last_lesson_name'] as String? ?? '',
        completedAt: json['completed_at'] != null
            ? DateTime.tryParse(json['completed_at'] as String)
            : null,
      );

  final String status;
  final List<String> watchedLessons;
  final String lastLessonName;
  final DateTime? completedAt;
}
