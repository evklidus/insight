import 'package:rest_client/rest_client.dart';

final class Course {
  Course({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tag,
  });

  factory Course.fromDTO(CourseDTO dto) => Course(
        id: dto.id.toString(),
        name: dto.name,
        imageUrl: dto.imageUrl,
        tag: dto.tag,
      );

  final String id;
  final String name;
  final String imageUrl;
  final String tag;
}
