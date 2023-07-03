import 'package:json_annotation/json_annotation.dart';

part 'token_dto.g.dart';

@JsonSerializable()
class TokenDTO {
  @JsonKey(name: "access_token")
  final String accessToken;

  @JsonKey(name: "token_type")
  final String tokenType;

  const TokenDTO({
    required this.accessToken,
    required this.tokenType,
  });

  factory TokenDTO.fromJson(Map<String, dynamic> json) =>
      _$TokenDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TokenDTOToJson(this);
}
