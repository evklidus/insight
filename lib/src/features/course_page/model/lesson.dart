import 'package:meta/meta.dart';

@immutable
final class Lesson {
  const Lesson({
    required this.id,
    required this.name,
    required this.videoUrl,
    this.completed = false,
  });

  factory Lesson.fromJson(Map json) => Lesson(
        id: json['id'] as String? ?? '',
        name: json['name'],
        videoUrl: json['video_url'],
        completed: json['completed'] as bool? ?? false,
      );

  final String id;
  final String name;
  final String videoUrl;
  final bool completed;
}
