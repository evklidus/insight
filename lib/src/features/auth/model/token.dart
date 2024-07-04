import 'package:meta/meta.dart';

@immutable
final class Token {
  const Token({
    required this.accessToken,
    required this.refreshToken,
  });

  factory Token.fromJson(Map json) => Token(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
      );

  final String accessToken;
  final String refreshToken;
}
