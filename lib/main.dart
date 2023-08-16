import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:insight/src/common/utils/format_error.dart';
import 'package:insight/src/core/bloc/insight_bloc_observer.dart';
import 'package:insight/src/core/di_container/di_container.dart';

import 'package:insight/src/core/theme/insight_theme.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  final _appTheme = InsightTheme();

  late final AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(repository: DIContainer.instance.authRepository);
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return BlocProvider(
      create: (context) => authBloc,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: _appTheme.getLightTheme(),
        darkTheme: _appTheme.getDarkTheme(),
        themeMode: ThemeMode.dark,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
