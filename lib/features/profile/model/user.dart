import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class User {
  const User({
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
  final String? avatarUrl;
  final String? firstName;
  final String? lastName;

  factory User.fromDTO(UserDTO dto) => User(
        id: dto.id,
        username: dto.username,
        email: dto.email,
        avatarUrl: dto.avatarUrl,
        firstName: dto.firstName,
        lastName: dto.lastName,
      );
}
