import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:insight/src/core/bloc/insight_bloc_observer.dart';
import 'package:insight/src/core/di_container/di_container.dart';

import 'package:insight/src/core/theme/insight_theme.dart';
import 'package:insight/src/core/navigation/app_router.dart';
import 'package:insight/src/features/auth/widget/screens/main/auth_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await DIContainer().initDeps();
  Bloc.observer = InsightBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _appRouter = AppRouter();
  final _appTheme = InsightTheme();

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: _appTheme.getLightTheme(),
      darkTheme: _appTheme.getDarkTheme(),
      themeMode: ThemeMode.dark,
      routerConfig: _appRouter.router,
      /*
          TODO: Выпилить этот MaterialApp.
          Сейчас используется из-за ошибки "No Overlay widget found" при нажатии на TextField
          */
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _appTheme.getLightTheme(),
        darkTheme: _appTheme.getDarkTheme(),
        themeMode: ThemeMode.dark,
        home: AuthScreen(child!),
      ),
    );
  }
}
