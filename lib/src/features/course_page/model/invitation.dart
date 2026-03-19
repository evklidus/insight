/// Статус приглашения на закрытый курс.
enum InvitationStatus {
  pending,
  accepted,
}

/// Модель приглашения пользователя на курс.
class Invitation {
  const Invitation({
    required this.inviteeEmail,
    required this.inviteeUsername,
    required this.status,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
        inviteeEmail: json['invitee_email'] as String?,
        inviteeUsername: json['invitee_username'] as String?,
        status: _parseStatus(json['status'] as String?),
      );

  static InvitationStatus _parseStatus(String? value) {
    if (value == null) return InvitationStatus.pending;
    switch (value.toLowerCase()) {
      case 'accepted':
        return InvitationStatus.accepted;
      case 'pending':
      default:
        return InvitationStatus.pending;
    }
  }

  /// Email приглашённого (если есть).
  final String? inviteeEmail;

  /// Никнейм приглашённого (если есть).
  final String? inviteeUsername;

  final InvitationStatus status;

  /// Отображаемое имя: email или никнейм; никнейм в скобках, если есть оба.
  String get displayName {
    final email = inviteeEmail;
    final username = inviteeUsername;
    if (email != null && username != null && username.isNotEmpty) {
      return '$email ($username)';
    }
    return email ?? username ?? '';
  }

  bool get isAccepted => status == InvitationStatus.accepted;
}
