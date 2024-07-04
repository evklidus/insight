import 'package:meta/meta.dart';

@immutable
final class Lesson {
  const Lesson({
    required this.name,
    required this.videoUrl,
  });

  factory Lesson.fromJson(Map json) => Lesson(
        name: json['name'],
        videoUrl: json['video_url'],
      );

  final String name;
  final String videoUrl;
}
