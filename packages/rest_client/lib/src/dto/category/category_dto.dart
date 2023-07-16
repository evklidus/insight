import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'category_dto.g.dart';

@JsonSerializable()
@immutable
class CategoryDTO {
  const CategoryDTO({
    required this.name,
    required this.imageUrl,
    required this.tag,
  });

  final String name;
  @JsonKey(name: "image_url")
  final String imageUrl;
  final String tag;

  factory CategoryDTO.fromJson(Map<String, Object?> json) =>
      _$CategoryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDTOToJson(this);
}
