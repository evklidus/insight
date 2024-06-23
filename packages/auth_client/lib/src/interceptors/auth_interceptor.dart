import 'package:dio/dio.dart';

import 'dart:async';
import 'dart:ui';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.getTokenFromDB,
    required this.signOut,
  });

  final FutureOr<String?> Function() getTokenFromDB;
  final VoidCallback signOut;

  @override
  void onRequest(options, handler) async {
    final token = await getTokenFromDB();
    if (token != null) {
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
