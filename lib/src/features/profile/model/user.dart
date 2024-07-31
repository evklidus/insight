import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:meta/meta.dart';

@immutable
final class User {
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    this.lastName,
    this.avatarUrl,
    this.username,
  });

  factory User.fromJson(Map json) => User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        avatarUrl: json['avatar_url'],
        firstName: json['first_name'],
        lastName: json['last_name'],
      );

  factory User.fromFirestore(
    String id,
    Map<String, dynamic>? userData,
  ) =>
      User(
        id: id,
        email: userData!['email'],
        avatarUrl: userData['avatar_url'],
        firstName: userData['first_name'],
        lastName: userData['last_name'],
        username: userData['username'],
      );

  final String id;
  final String email;
  final String firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? username;

  String get fullName =>
      lastName.isNotNull ? '$firstName $lastName' : firstName;

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    String? firstName,
    String? lastName,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );
}
