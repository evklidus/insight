import 'package:rest_client/rest_client.dart';

final class CoursePreview {
  CoursePreview({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tag,
  });

  factory CoursePreview.fromDTO(CoursePreviewDTO dto) => CoursePreview(
        id: dto.id,
        name: dto.name,
        imageUrl: dto.imageUrl,
        tag: dto.tag,
      );

  final int id;
  final String name;
  final String imageUrl;
  final String tag;
}
