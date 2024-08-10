import 'package:meta/meta.dart';

@immutable
final class User$Edit {
  const User$Edit({
    required this.id,
    this.avatarPath,
    this.firstName,
    this.lastName,
    this.username,
  });

  final String id;
  final String? avatarPath;
  final String? firstName;
  final String? lastName;
  final String? username;
}
