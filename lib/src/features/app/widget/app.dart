import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/app/widget/material_context.dart';
import 'package:insight/src/features/auth/bloc/auth_bloc.dart';
import 'package:insight/src/features/settings/bloc/settings_bloc.dart';
import 'package:insight/src/features/settings/widget/settings_scope.dart';

/// {@template app}
/// [App] is an entry point to the application.
///
/// Scopes that don't depend on widgets returned by [MaterialApp]
/// ([Directionality], [MediaQuery], [Localizations]) should be placed here.
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro app}
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthBloc _authBloc;
  late final SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(repository: DIContainer.instance.authRepository)
      ..add(const AuthEvent.checkStatus());
    _settingsBloc = SettingsBloc(
      themeRepository: DIContainer.instance.themeRepository,
      initialState: SettingsState.idle(appTheme: DIContainer.instance.theme),
    );
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return BlocProvider(
      create: (context) => _authBloc,
      child: SettingsScope(
        settingsBloc: _settingsBloc,
        child: const MaterialContext(),
      ),
    );
  }
}
