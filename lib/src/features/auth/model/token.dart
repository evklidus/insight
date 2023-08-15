import 'package:auth_client/auth_client.dart';
import 'package:meta/meta.dart';

@immutable
final class Token {
  const Token({
    required this.accessToken,
    this.refreshToken,
  });

  factory Token.fromDTO(TokenDTO dto) => Token(
        accessToken: dto.accessToken,
      );

  final String accessToken;
  final String? refreshToken;
}
