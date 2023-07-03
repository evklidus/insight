import 'package:insight/features/auth/data/data_sources/auth_data_source.dart';

abstract class AuthRepository {
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

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this.authDataSource);

  final AuthDataSource authDataSource;

  @override
  Future<void> register(String username, String password) async {
    await authDataSource.register(username, password);
  }

  @override
  Future<void> login(String username, String password) async {
    return authDataSource.login(username, password);
  }

  @override
  Future<bool> checkAuthenticatedStatus() async {
    return await authDataSource.checkAuthenticatedStatus();
  }

  @override
  Future<void> logout() async {
    await authDataSource.logout();
  }
}
