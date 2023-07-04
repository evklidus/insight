class UserDTO {
  final String username;

  UserDTO({
    required this.username,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      username: json['user']['username'],
    );
  }
}
