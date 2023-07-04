import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:insight/app_theme.dart';
import 'package:insight/core/di/locator_service.dart' as di;
import 'package:insight/core/navigation/app_router.dart';
import 'package:insight/features/auth/widget/screens/main/auth_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await di.setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _appRouter = di.getIt<AppRouter>();
  final _appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: _appTheme.getLightTheme(),
      darkTheme: _appTheme.getDarkTheme(),
      themeMode: ThemeMode.dark,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
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
