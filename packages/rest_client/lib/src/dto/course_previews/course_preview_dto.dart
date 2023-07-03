import 'package:json_annotation/json_annotation.dart';

part 'course_preview_dto.g.dart';

@JsonSerializable()
class CoursePreviewDTO {
  const CoursePreviewDTO({
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

  factory CoursePreviewDTO.fromJson(Map<String, Object?> json) =>
      _$CoursePreviewDTOFromJson(json);
}
