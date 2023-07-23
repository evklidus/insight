import 'package:auth_client/auth_client.dart';
import 'package:meta/meta.dart';

@immutable
final class Token {
  const Token({
    required this.accessToken,
    required this.tokenType,
  });

  factory Token.fromDTO(TokenDTO dto) => Token(
        accessToken: dto.accessToken,
        tokenType: dto.tokenType,
      );

  final String accessToken;
  final String tokenType;
}
