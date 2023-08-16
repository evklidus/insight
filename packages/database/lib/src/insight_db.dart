import 'dart:async';

import 'package:database/src/insight_db_base.dart';

abstract class InsightDB {
  InsightDB._();

  static FutureOr<InsightDB> getInstance() => InsightDBBase.getInstance();

  FutureOr<void> saveCredentials({
    required String accessToken,
    String? refreshToken,
  });

  FutureOr<String?> getToken();

  FutureOr<String?> getRefreshToken();

  FutureOr<void> clearCredentials();

  FutureOr<void> setAuthorizedStatus(bool isAuthorized);

  FutureOr<bool?> isAuthorized();
}
