/// Статус приглашения на закрытый курс.
enum InvitationStatus {
  pending,
  accepted,
}

/// Модель приглашения пользователя на курс.
class Invitation {
  const Invitation({
    required this.emailOrNickname,
    required this.status,
  });

  final String emailOrNickname;
  final InvitationStatus status;

  bool get isAccepted => status == InvitationStatus.accepted;
}
