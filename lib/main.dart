import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/app_theme.dart';
import 'package:insight/common/di/locator_service.dart' as di;
import 'package:insight/common/navigation/app_router.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  di.setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _appRouter = di.getIt<AppRouter>();
  final appTheme = AppTheme();
  final designSize = const Size(393, 852);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: appTheme.getLightTheme(),
          darkTheme: appTheme.getDarkTheme(),
          themeMode: ThemeMode.dark,
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
        );
      },
    );
  }
}
