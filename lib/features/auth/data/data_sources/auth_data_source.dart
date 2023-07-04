import 'package:auth_client/auth_client.dart';
import 'package:database/insight_db.dart';

abstract class AuthDataSource {
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

class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({
    required this.authClient,
    required this.insightDB,
  });

  final AuthClient authClient;
  final InsightDB insightDB;

  @override
  Future<void> register(
    String username,
    String password,
  ) async {
    return await authClient.register(username, password);
  }

  @override
  Future<void> login(
    String username,
    String password,
  ) async {
    final token = await authClient.login(username, password);
    await insightDB.saveToken(token.accessToken);
    await insightDB.setAuthorizedStatus(true);
  }

  @override
  Future<bool> checkAuthenticatedStatus() async {
    return await insightDB.isAuthorized() ?? false;
  }

  @override
  Future<void> logout() async {
    await insightDB.clearToken();
    await insightDB.setAuthorizedStatus(false);
  }
}
