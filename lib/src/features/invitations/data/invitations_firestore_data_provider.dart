import 'package:insight/src/features/invitations/data/invitations_network_data_provider.dart';
import 'package:insight/src/features/invitations/model/user_invitation.dart';

/// Заглушка для режима Firebase — приглашения через backend API недоступны.
final class InvitationsFirestoreDataProviderImpl
    implements InvitationsNetworkDataProvider {
  const InvitationsFirestoreDataProviderImpl();

  @override
  Future<List<UserInvitation>> getMyInvitations() async => [];

  @override
  Future<void> acceptInvitation(String invitationId) async {}
}
