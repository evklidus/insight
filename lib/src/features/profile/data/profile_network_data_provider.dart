import 'package:insight/src/features/profile/model/user.dart';
import 'package:rest_client/rest_client.dart';

abstract interface class ProfileNetworkDataProvider {
  Future<User> getUser();
}

final class ProfileNetworkDataProviderImpl
    implements ProfileNetworkDataProvider {
  const ProfileNetworkDataProviderImpl(RestClient client) : _client = client;

  final RestClient _client;

  @override
  Future<User> getUser() => _client.getUser().then(User.fromDTO);
}
