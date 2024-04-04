import 'dart:io';

import 'package:insight/src/common/constants/app_strings.dart';

String exceptionToMessage(Object exception) {
  return switch (exception) {
    SocketException _ => AppStrings.noInternetConnection,
    _ => AppStrings.somethingWrong,
  };
}
