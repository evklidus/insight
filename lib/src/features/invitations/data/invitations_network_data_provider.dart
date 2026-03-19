import 'package:dio/dio.dart';
import 'package:insight/src/features/invitations/model/user_invitation.dart';

abstract interface class InvitationsNetworkDataProvider {
  /// Возвращает приглашения текущего пользователя на курсы.
  Future<List<UserInvitation>> getMyInvitations();

  /// Принимает приглашение по id.
  Future<void> acceptInvitation(String invitationId);
}

final class InvitationsNetworkDataProviderImpl
    implements InvitationsNetworkDataProvider {
  const InvitationsNetworkDataProviderImpl(Dio client) : _client = client;
  final Dio _client;

  @override
  Future<List<UserInvitation>> getMyInvitations() async {
    final response = await _client.get('/invitations/me');

    if (response.data case {'message': final String message, 'statusCode': final int code}) {
      throw Exception('[$code] $message');
    }

    if (response.data case final List invitationsJson) {
      return invitationsJson
          .cast<Map<String, dynamic>>()
          .map(UserInvitation.fromJson)
          .toList(growable: false);
    }

    throw FormatException(
      'Unexpected getMyInvitations response',
      response.data,
    );
  }

  @override
  Future<void> acceptInvitation(String invitationId) async {
    final response = await _client.post('/invitations/$invitationId/accept');

    if (response.data case {'message': final String message, 'statusCode': final int code}) {
      throw Exception('[$code] $message');
    }
  }
}
