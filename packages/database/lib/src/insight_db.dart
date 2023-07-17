import 'dart:async';

import 'package:database/src/insight_db_base.dart';

abstract class InsightDB {
  InsightDB._();

  static FutureOr<InsightDB> getInstance() => InsightDBBase.getInstance();

  FutureOr<void> saveToken(String token);

  FutureOr<String?> getToken();

  FutureOr<void> clearToken();

  FutureOr<void> setAuthorizedStatus(bool isAuthorized);

  FutureOr<bool?> isAuthorized();
}
