import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:insight/services/di/locator_service.dart' as di;
import 'package:insight/services/links/applinks_service.dart';
import 'package:insight/services/navigation/app_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.setup();
  // checkIfStartedByLink();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _appRouter = di.getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp.router(
        theme: ThemeData(useMaterial3: true),
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
      );
    });
  }
}

// Future<void> checkIfStartedByLink() async {
//   final appLinksService = di.getIt<AppLinksService>();
//   final uri = await appLinksService.appLinks.getInitialAppLink();
//   if (uri != null) {
//     appLinksService.appLinksProvider.pushUrlCoolBoot(uri);
//   }
// }
