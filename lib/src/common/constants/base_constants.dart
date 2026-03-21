import 'dart:io';

import 'package:insight/src/common/utils/current_flavor.dart';

// UI

const standartDuration = Duration(milliseconds: 150);

final isNeedCupertino = Platform.isIOS || Platform.isMacOS;

// Url's
const _apiVersion = '/v1';
const _devApiHost = 'https://dev-insight-api.uchu.academy';
const _prodApiHost = 'https://insight-api.uchu.academy';

String get _defaultApiHost => Flavor.isProd ? _prodApiHost : _devApiHost;

String get _localApiHost {
  final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  return 'http://$host:8080';
}

String get _apiHost {
  const overrideApiHost = String.fromEnvironment('API_HOST');
  if (overrideApiHost.isNotEmpty) {
    return overrideApiHost;
  }

  const useLocalApi = bool.fromEnvironment(
    'USE_LOCAL_API',
    defaultValue: false,
  );
  if (useLocalApi) {
    return _localApiHost;
  }

  return _defaultApiHost;
}

String get kBaseUrl => '$_apiHost$_apiVersion';

String get kBaseUrlWithoutVersion => _apiHost;

/// Преобразует относительный путь storage в полный URL.
/// Бэкенд раздаёт статику по /storage (например: /storage/images/users/...).
String resolveStorageUrl(String? url) {
  if (url == null || url.isEmpty) return '';
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  final base = kBaseUrlWithoutVersion;
  final path =
      url.startsWith('/storage') ? url : '/storage/${url.replaceFirst(RegExp(r'^/+'), '')}';
  return '$base$path';
}
