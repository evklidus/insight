import 'package:auth_client/auth_client.dart';
import 'package:insight/src/features/auth/model/token.dart';

abstract interface class AuthNetworkDataProvider {
  Future<void> register(
    String username,
    String password,
  );
  Future<Token> login(
    String username,
    String password,
  );
}

final class AuthNetworkDataProviderImpl implements AuthNetworkDataProvider {
  AuthNetworkDataProviderImpl(AuthClient authClient) : _authClient = authClient;

  final AuthClient _authClient;

  @override
  Future<void> register(
    String username,
    String password,
  ) =>
      _authClient.register(username, password);

  @override
  Future<Token> login(
    String username,
    String password,
  ) =>
      _authClient.login(username, password).then(Token.fromDTO);
}
