import 'package:rest_client/rest_client.dart';

final class Course {
  Course({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tag,
  });

  factory Course.fromDTO(CourseDTO dto) => Course(
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
