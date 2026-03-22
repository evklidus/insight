import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/utils/preferences_dao.dart';

abstract interface class AuthStorageDataProvider {
  Future<bool> checkAuthenticatedStatus();

  Future<String?> getRefreshToken();

  Future<void> setLoginData({
    required String accessToken,
    String? refreshToken,
  });

  Future<void> setLogout();
}

final class AuthStorageDataProviderImpl extends PreferencesDao
    implements AuthStorageDataProvider {
  AuthStorageDataProviderImpl({required super.sharedPreferences});

  PreferencesEntry<String> get _accessToken => stringEntry('auth.accessToken');

  PreferencesEntry<String> get _refreshToken =>
      stringEntry('auth.refreshToken');

  @override
  Future<bool> checkAuthenticatedStatus() async {
    return _accessToken.read().isNotNull;
  }

  @override
  Future<String?> getRefreshToken() async => _refreshToken.read();

  @override
  Future<void> setLoginData({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _accessToken.set(accessToken);
    if (refreshToken != null) {
      await _refreshToken.set(refreshToken);
    }
  }

  @override
  Future<void> setLogout() async {
    await (_accessToken.remove(), _refreshToken.remove()).wait;
  }
}
