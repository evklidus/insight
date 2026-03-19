import 'package:meta/meta.dart';

import 'package:insight/src/features/invitations/model/user_invitation.dart';

@immutable
final class InvitationsState {
  const InvitationsState({
    this.invitations = const [],
    this.isProcessing = false,
    this.hasError = false,
    this.message,
  });

  final List<UserInvitation> invitations;
  final bool isProcessing;
  final bool hasError;
  final String? message;

  bool get hasData => !isProcessing && !hasError;

  InvitationsState copyWith({
    List<UserInvitation>? invitations,
    bool? isProcessing,
    bool? hasError,
    String? message,
  }) =>
      InvitationsState(
        invitations: invitations ?? this.invitations,
        isProcessing: isProcessing ?? this.isProcessing,
        hasError: hasError ?? this.hasError,
        message: message ?? this.message,
      );
}
