import 'dart:io';

const standartDuration = Duration(milliseconds: 150);

final isNeddCupertino = Platform.isIOS || Platform.isMacOS;

// Url's
const _apiVersion = '/v1';

const kBaseUrl = 'https://0.0.0.0:8080$_apiVersion';
