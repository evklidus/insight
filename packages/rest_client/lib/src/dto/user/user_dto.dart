import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user_dto.g.dart';

@JsonSerializable()
@immutable
class UserDTO {
  const UserDTO({
    this.id,
    required this.username,
    this.email,
    this.avatarUrl,
    this.firstName,
    this.lastName,
  });

  final int? id;
  final String username;
  final String? email;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;

  factory UserDTO.fromJson(Map<String, Object?> json) =>
      _$UserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserDTOToJson(this);
}
