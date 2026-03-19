import 'dart:io';

import 'package:insight/src/common/utils/current_flavor.dart';

// UI

const standartDuration = Duration(milliseconds: 150);

final isNeedCupertino = Platform.isIOS || Platform.isMacOS;

// Url's
const _apiVersion = '/v1';

String get kBaseUrl {
  if (Flavor.isProd) {
    return 'https://api.insight.example.com$_apiVersion';
  }
  final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  return 'http://$host:8080$_apiVersion';
}

String get kBaseUrlWithoutVersion {
  if (Flavor.isProd) {
    return 'https://api.insight.example.com';
  }
  final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  return 'http://$host:8080';
}

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
