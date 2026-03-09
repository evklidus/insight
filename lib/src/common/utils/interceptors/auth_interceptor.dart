import 'dart:ui';

import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.getTokenFromDB,
    required this.refreshToken,
    this.tryRefreshToken,
    this.retryDio,
  });

  final Future<String?> Function() getTokenFromDB;
  final VoidCallback refreshToken;

  /// При 401: вызывает tryRefreshToken; при true — повторяет запрос с новым токеном.
  final Future<bool> Function()? tryRefreshToken;

  /// Dio-клиент для retry (restClient). Нужен, если задан tryRefreshToken.
  final Dio? retryDio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    getTokenFromDB().then((token) {
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    });
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        tryRefreshToken != null &&
        retryDio != null) {
      final refreshed = await tryRefreshToken!();
      if (refreshed) {
        final token = await getTokenFromDB();
        if (token != null) {
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $token';
          try {
            final response = await retryDio!.fetch(opts);
            return handler.resolve(response);
          } catch (_) {
            // fall through to logout
          }
        }
      }
      refreshToken();
    } else if (err.response?.statusCode == 401) {
      refreshToken();
    }
    handler.reject(err);
  }
}
