import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/app/widget/material_context.dart';
import 'package:insight/src/features/auth/widget/auth_scope.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
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
  late final ProfileBloc _profileBloc;
  late final SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _profileBloc = ProfileBloc(
      repository: DIContainer.instance.profileRepository,
    )..add(const ProfileEvent.fetch());

    _settingsBloc = SettingsBloc(
      themeRepository: DIContainer.instance.themeRepository,
      initialState: SettingsState.idle(appTheme: DIContainer.instance.theme),
    );
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return BlocProvider(
      create: (context) => _profileBloc,
      child: SettingsScope(
        settingsBloc: _settingsBloc,
        child: const AuthScope(
          MaterialContext(),
        ),
      ),
    );
  }
}
