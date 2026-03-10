part of 'invitations_bloc.dart';

sealed class InvitationsEvent {
  const InvitationsEvent();

  static const InvitationsEvent fetch = _InvitationsEvent$Fetch();
}

final class _InvitationsEvent$Fetch extends InvitationsEvent {
  const _InvitationsEvent$Fetch();
}
