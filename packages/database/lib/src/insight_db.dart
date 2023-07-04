import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

abstract class InsightDB {
  factory InsightDB() = InsightDBBase;

  Future<void> init();

  FutureOr<void> saveToken(String token);

  FutureOr<String?> getToken();

  FutureOr<void> clearToken();

  FutureOr<void> setAuthorizedStatus(bool isAuthorized);

  FutureOr<bool?> isAuthorized();
}

class InsightDBBase implements InsightDB {
  static final InsightDBBase _instance = InsightDBBase._internal();

  factory InsightDBBase() {
    return _instance;
  }

  InsightDBBase._internal();

  @override
  Future<void> init() async {
    await _initPrefs();
  }

  late final SharedPreferences prefs;

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  FutureOr<void> saveToken(String token) {
    prefs.setString('token', token);
  }

  @override
  FutureOr<String?> getToken() {
    return prefs.getString('token');
  }

  @override
  FutureOr<void> clearToken() {
    prefs.remove('token');
  }

  @override
  FutureOr<void> setAuthorizedStatus(bool isAuthorized) {
    prefs.setBool('isAuthorized', isAuthorized);
  }

  @override
  FutureOr<bool?> isAuthorized() {
    return prefs.getBool('isAuthorized');
  }
}
