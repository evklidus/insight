import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:insight/src/common/utils/format_error.dart';
import 'package:insight/src/core/bloc/insight_bloc_observer.dart';
import 'package:insight/src/core/di_container/di_container.dart';

import 'package:insight/src/core/theme/custom_theme.dart';
import 'package:insight/src/core/navigation/app_router.dart';
import 'package:insight/src/features/auth/bloc/auth_bloc.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DIContainer.instance.initDeps();
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
  Bloc.observer = InsightBlocObserver();
  Bloc.transformer = sequential();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(repository: DIContainer.instance.authRepository)
      ..add(const AuthEvent.checkStatus());
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return BlocProvider(
      create: (context) => _authBloc,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: ThemeMode.dark,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
