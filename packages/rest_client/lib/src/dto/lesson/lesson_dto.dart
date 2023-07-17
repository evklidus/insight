import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'lesson_dto.g.dart';

@JsonSerializable()
@immutable
class LessonDTO {
  const LessonDTO({
    required this.name,
    required this.videoUrl,
  });

  final String name;
  @JsonKey(name: "video_url")
  final String videoUrl;

  factory LessonDTO.fromJson(Map<String, Object?> json) =>
      _$LessonDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LessonDTOToJson(this);
}
