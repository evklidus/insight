import 'package:flutter/material.dart';
import 'package:insight/src/common/widgets/adaptive_button.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/features/settings/widget/settings_scope.dart';

/// {@template theme_screen}
/// ThemeScreen widget.
/// {@endtemplate}
class ThemeScreen extends StatelessWidget {
  /// {@macro theme_screen}
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = SettingsScope.themeOf(context);
    return Scaffold(
      appBar: const CustomAppBar('Смена темы'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ThemeButton(
              onPressed: () => theme.setThemeMode(ThemeMode.light),
              text: 'Светлая',
            ),
            _ThemeButton(
              onPressed: () => theme.setThemeMode(ThemeMode.dark),
              text: 'Темная',
            ),
            _ThemeButton(
              onPressed: () => theme.setThemeMode(ThemeMode.system),
              text: 'Системная',
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  const _ThemeButton({
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) => AdaptiveButton.filled(
        onPressed: onPressed,
        child: Text(text),
      );
}
