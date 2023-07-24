import 'package:database/insight_db.dart';

abstract interface class AuthStorageDataProvider {
  Future<bool> checkAuthenticatedStatus();

  Future<void> setLoginData(String accessToken);

  Future<void> setLogout();
}

final class AuthStorageDataProviderImpl implements AuthStorageDataProvider {
  AuthStorageDataProviderImpl(InsightDB insightDB) : _insightDB = insightDB;

  final InsightDB _insightDB;

  @override
  Future<bool> checkAuthenticatedStatus() async {
    return await _insightDB.isAuthorized() ?? false;
  }

  @override
  Future<void> setLoginData(String accessToken) async {
    await _insightDB.saveToken(accessToken);
    await _insightDB.setAuthorizedStatus(true);
  }

  @override
  Future<void> setLogout() async {
    await _insightDB.clearToken();
    await _insightDB.setAuthorizedStatus(false);
  }
}
