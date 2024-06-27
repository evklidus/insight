import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:insight/src/common/utils/format_error.dart';
import 'package:insight/src/core/bloc/insight_bloc_observer.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/app/widget/app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Base setup
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Firebase setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Dependencies setup
  await DIContainer.instance.initDeps();

  // Errors setup
  final sourceFlutterError = FlutterError.onError;

  FlutterError.onError = (details) {
    debugPrint(formatError(
      '🦄 FlutterError',
      details.exceptionAsString(),
      details.stack,
    ));
    sourceFlutterError?.call(details);
  };

  PlatformDispatcher.instance.onError = (exception, stackTrace) {
    debugPrint(formatError(
      '🖥️ PlatformDispatcher',
      exception.toString(),
      stackTrace,
    ));
    return true;
  };

  // Bloc setup
  Bloc.observer = InsightBlocObserver();
  Bloc.transformer = sequential();

  runApp(const App());
}
