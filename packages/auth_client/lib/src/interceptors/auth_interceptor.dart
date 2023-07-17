import 'package:dio/dio.dart';

import 'dart:async';
import 'dart:ui';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.isAuthorizedFromDB,
    required this.getTokenFromDB,
    required this.signOut,
  });

  final FutureOr<bool?> Function() isAuthorizedFromDB;
  final FutureOr<String?> Function() getTokenFromDB;
  final VoidCallback signOut;

  @override
  void onRequest(options, handler) async {
    final isAuthorized = await isAuthorizedFromDB();
    if (isAuthorized ?? false) {
      final token = await getTokenFromDB();
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(err, handler) {
    if (err.response?.statusCode == 401) {
      // TODO: Добавить рефреш токена
      // Если и рефреш протух - тогда signOut()
      signOut();
    } else {
      super.onError(err, handler);
    }
  }
}
