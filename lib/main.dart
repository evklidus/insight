import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:insight/src/core/bloc/insight_bloc_observer.dart';
import 'package:insight/src/core/di_container/di_container.dart';

import 'package:insight/src/core/theme/insight_theme.dart';
import 'package:insight/src/core/navigation/app_router.dart';
import 'package:insight/src/features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await DIContainer().initDeps();
  Bloc.observer = InsightBlocObserver();
  Bloc.transformer = sequential();
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
    authBloc = AuthBloc(repository: DIContainer().authRepository);
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
