import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/src/dto/lesson/lesson_dto.dart';

part 'course_page_dto.g.dart';

@JsonSerializable()
class CoursePageDTO {
  const CoursePageDTO({
    required this.id,
    required this.imageUrl,
    required this.lessons,
  });

  final int id;
  @JsonKey(name: "image_url")
  final String imageUrl;
  final List<LessonDTO> lessons;

  factory CoursePageDTO.fromJson(Map<String, Object?> json) =>
      _$CoursePageDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CoursePageDTOToJson(this);
}
