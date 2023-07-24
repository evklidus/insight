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

  Stream<bool> get isAuthenticatedStream;
}

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthNetworkDataProvider networkDataProvider,
    required AuthStorageDataProvider storageDataProvider,
    required Stream<bool> isAuthenticatedStream,
  })  : _networkDataProvider = networkDataProvider,
        _storageDataProvider = storageDataProvider,
        _isAuthenticatedStream = isAuthenticatedStream;

  final AuthNetworkDataProvider _networkDataProvider;
  final AuthStorageDataProvider _storageDataProvider;
  final Stream<bool> _isAuthenticatedStream;

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

  @override
  Stream<bool> get isAuthenticatedStream => _isAuthenticatedStream;
}
