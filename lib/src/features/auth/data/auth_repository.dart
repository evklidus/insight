import 'package:insight/src/features/auth/data/auth_network_data_provider.dart';
import 'package:insight/src/features/auth/data/auth_storage_data_provider.dart';

abstract interface class AuthRepository {
  Future<void> register(
    String username,
    String password,
  );

  Future<void> login(
    String username,
    String password,
  );

  Future<bool> checkAuthenticatedStatus();

  Future<void> logout();
}

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthNetworkDataProvider networkDataProvider,
    required AuthStorageDataProvider storageDataProvider,
  })  : _networkDataProvider = networkDataProvider,
        _storageDataProvider = storageDataProvider;

  final AuthNetworkDataProvider _networkDataProvider;
  final AuthStorageDataProvider _storageDataProvider;

  @override
  Future<bool> checkAuthenticatedStatus() =>
      _storageDataProvider.checkAuthenticatedStatus();

  @override
  Future<void> register(String username, String password) async {
    await _networkDataProvider.register(username, password);
  }

  @override
  Future<void> login(String username, String password) async {
    final token = await _networkDataProvider.login(username, password);
    await _storageDataProvider.setLoginData(token.accessToken);
  }

  @override
  Future<void> logout() async {
    await _storageDataProvider.setLogout();
  }
}
