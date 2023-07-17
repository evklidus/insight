import 'dart:async';

import 'package:database/src/insight_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsightDBBase implements InsightDB {
  InsightDBBase._internal();

  static FutureOr<InsightDB> getInstance() async {
    // if not initialazed
    if (_instance == null) {
      // initialization
      _instance = InsightDBBase._internal();
      await _instance!._initPrefs();
    }
    return _instance!;
  }

  static InsightDBBase? _instance;

  late final SharedPreferences _prefs;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  FutureOr<void> saveToken(String token) {
    _prefs.setString('token', token);
  }

  @override
  FutureOr<String?> getToken() {
    return _prefs.getString('token');
  }

  @override
  FutureOr<void> clearToken() {
    _prefs.remove('token');
  }

  @override
  FutureOr<void> setAuthorizedStatus(bool isAuthorized) {
    _prefs.setBool('isAuthorized', isAuthorized);
  }

  @override
  FutureOr<bool?> isAuthorized() {
    return _prefs.getBool('isAuthorized');
  }
}
