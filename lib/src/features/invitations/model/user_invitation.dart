import 'package:meta/meta.dart';

/// Статус приглашения пользователя на курс.
enum UserInvitationStatus {
  pending,
  accepted,
  rejected,
  unknown,
}

/// Модель приглашения текущего пользователя на курс.
@immutable
final class UserInvitation {
  const UserInvitation({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.createdAt,
    required this.inviterId,
    required this.status,
  });

  factory UserInvitation.fromJson(Map<String, dynamic> json) =>
      UserInvitation(
        id: json['id'] as String,
        courseId: json['course_id'] as String,
        courseName: json['course_name'] as String,
        createdAt: json['created_at'] as String,
        inviterId: json['inviter_id'] as String,
        status: _parseStatus(json['status'] as String?),
      );

  static UserInvitationStatus _parseStatus(String? value) {
    if (value == null) return UserInvitationStatus.unknown;
    switch (value.toLowerCase()) {
      case 'pending':
        return UserInvitationStatus.pending;
      case 'accepted':
        return UserInvitationStatus.accepted;
      case 'rejected':
        return UserInvitationStatus.rejected;
      default:
        return UserInvitationStatus.unknown;
    }
  }

  final String id;
  final String courseId;
  final String courseName;
  final String createdAt;
  final String inviterId;
  final UserInvitationStatus status;

  bool get isAccepted => status == UserInvitationStatus.accepted;
  bool get isPending => status == UserInvitationStatus.pending;
}
