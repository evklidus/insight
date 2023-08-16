import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'course_dto.g.dart';

@JsonSerializable()
@immutable
class CourseDTO {
  const CourseDTO({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tag,
  });

  final int id;
  final String name;
  @JsonKey(name: "image_url")
  final String imageUrl;
  final String tag;

  factory CourseDTO.fromJson(Map<String, Object?> json) =>
      _$CourseDTOFromJson(json);
}
