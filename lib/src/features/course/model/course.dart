import 'package:rest_client/rest_client.dart';

class Course {
  const Course({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tag,
    required this.isItsOwn,
  });

  factory Course.fromDTO(CourseDTO dto, String userId) => Course(
        id: dto.id.toString(),
        name: dto.name,
        imageUrl: dto.imageUrl,
        tag: dto.tag,
        isItsOwn: userId == dto.ownerId,
      );

  factory Course.fromFirestore(
    String id,
    Map<String, dynamic>? data,
    String? userId,
  ) =>
      Course(
        id: id,
        name: data!['name'],
        imageUrl: data['image_url'],
        tag: data['tag'],
        isItsOwn: data['owner_id'] == userId,
      );

  final String id;
  final String name;
  final String imageUrl;
  final String tag;
  final bool isItsOwn;
}
