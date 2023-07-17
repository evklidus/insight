import 'package:insight/features/profile/model/user.dart';
import 'package:rest_client/rest_client.dart';

abstract class ProfileDataProvider {
  Future<User> getUser();
}

/*
TODO: Сделать так везде:
1. _client = client
2. getUser() => client.getUser().then((value) => null); (чтобы не писать везде async)
3. Переименовать из Source в Provider
*/

// TODO: Добавить в название Network/Remote/...
class ProfileDataProviderImpl implements ProfileDataProvider {
  const ProfileDataProviderImpl(RestClient client) : _client = client;

  final RestClient _client;

  @override
  Future<User> getUser() => _client.getUser().then(User.fromDTO);
}
