import 'package:insight/src/features/invitations/data/invitations_network_data_provider.dart';
import 'package:insight/src/features/invitations/model/user_invitation.dart';

abstract interface class InvitationsRepository {
  Future<List<UserInvitation>> getMyInvitations();
  Future<void> acceptInvitation(String invitationId);
}

final class InvitationsRepositoryImpl implements InvitationsRepository {
  const InvitationsRepositoryImpl({
    required InvitationsNetworkDataProvider networkDataProvider,
  }) : _networkDataProvider = networkDataProvider;

  final InvitationsNetworkDataProvider _networkDataProvider;

  @override
  Future<List<UserInvitation>> getMyInvitations() =>
      _networkDataProvider.getMyInvitations();

  @override
  Future<void> acceptInvitation(String invitationId) =>
      _networkDataProvider.acceptInvitation(invitationId);
}
