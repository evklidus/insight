import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:m_sport/services/navigation/app_router.dart';
import 'package:m_sport/services/navigation/guards/internet_guard.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _appRouter = AppRouter(internetGuard: InternetGuard());

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(),
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
