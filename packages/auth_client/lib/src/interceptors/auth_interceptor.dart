import 'dart:async';

import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.isAuthorizedFromDB,
    required this.getTokenFromDB,
  });

  final FutureOr<bool?> Function() isAuthorizedFromDB;
  final FutureOr<String?> Function() getTokenFromDB;

  @override
  // TODO: Добавить refresh токена
  void onRequest(options, handler) async {
    final isAuthorized = await isAuthorizedFromDB();
    if (isAuthorized ?? false) {
      final token = await getTokenFromDB();
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
