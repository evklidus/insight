import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
final class Lesson {
  const Lesson({
    required this.name,
    required this.videoUrl,
  });

  factory Lesson.fromDTO(LessonDTO dto) => Lesson(
        name: dto.name,
        videoUrl: dto.videoUrl,
      );

  final String name;
  final String videoUrl;
}
