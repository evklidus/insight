import 'package:auth_client/auth_client.dart';
import 'package:insight/features/auth/data/entities/token_entity.dart';

extension TokenMapper on TokenDTO {
  TokenEntity toEntity() {
    return TokenEntity(
      accessToken: accessToken,
      tokenType: tokenType,
    );
  }
}
