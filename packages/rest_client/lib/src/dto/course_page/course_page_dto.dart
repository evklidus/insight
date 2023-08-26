import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/src/dto/lesson/lesson_dto.dart';

part 'course_page_dto.g.dart';

@JsonSerializable()
@immutable
class CoursePageDTO {
  const CoursePageDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.lessons,
  });

  factory CoursePageDTO.fromJson(Map<String, Object?> json) =>
      _$CoursePageDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CoursePageDTOToJson(this);

  final int id;
  final String name;
  final String description;
  @JsonKey(name: "image_url")
  final String imageUrl;
  final List<LessonDTO> lessons;
}
