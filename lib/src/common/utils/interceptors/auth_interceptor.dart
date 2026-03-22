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

  /// Один параллельный refresh на все 401 (ротация refresh на бэкенде).
  Future<bool>? _refreshInFlight;

  /// Ждущие 401 получают тот же [Future], что и первая попытка refresh.
  Future<bool> _runRefreshLocked() => _refreshInFlight ??= _refreshOnce();

  Future<bool> _refreshOnce() async {
    try {
      return await tryRefreshToken!();
    } finally {
      _refreshInFlight = null;
    }
  }

  /// Логаут только если сервер отклонил уже новый access (401/403). Сеть/таймаут — сессия живая.
  static bool _shouldLogoutAfterRetryError(Object error) {
    if (error is! DioException) return false;
    final code = error.response?.statusCode;
    if (code == null) return false;
    return code == 401 || code == 403;
  }

  static DioException _dioExceptionForRetry(RequestOptions opts, Object e) =>
      e is DioException
          ? e
          : DioException(
              requestOptions: opts,
              error: e,
              type: DioExceptionType.unknown,
            );

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
      final refreshed = await _runRefreshLocked();
      if (refreshed) {
        final token = await getTokenFromDB();
        if (token != null) {
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $token';
          try {
            final response = await retryDio!.fetch(opts);
            return handler.resolve(response);
          } catch (e) {
            final dioErr = _dioExceptionForRetry(opts, e);
            if (_shouldLogoutAfterRetryError(e)) {
              refreshToken();
            }
            return handler.reject(dioErr);
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
