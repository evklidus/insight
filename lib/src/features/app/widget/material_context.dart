import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/app_colors.dart';
import 'package:insight/src/core/navigation/app_router.dart';
import 'package:insight/src/features/settings/widget/settings_scope.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class MaterialContext extends StatefulWidget {
  /// {@macro material_context}
  const MaterialContext({super.key});

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final theme = SettingsScope.themeOf(context).theme;
    final currentTheme = theme.computeTheme();

    return MaterialApp.router(
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.mode,
      routerConfig: _appRouter.router,
      builder: (context, child) {
        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: currentTheme.brightness,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: currentTheme.scaffoldBackgroundColor,
          ),
          child: Material(child: child),
        );
      },
    );
  }
}
