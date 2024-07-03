import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/features/settings/widget/settings_scope.dart';

/// {@template theme_screen}
/// ThemeScreen widget.
/// {@endtemplate}
class ThemeChangeWidget extends StatelessWidget {
  /// {@macro theme_screen}
  const ThemeChangeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = SettingsScope.themeOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ThemeButton(
            onPressed: () => theme.setThemeMode(ThemeMode.light),
            isOn: theme.theme.mode == ThemeMode.light,
            text: 'Светлая',
          ),
          _ThemeButton(
            onPressed: () => theme.setThemeMode(ThemeMode.dark),
            isOn: theme.theme.mode == ThemeMode.dark,
            text: 'Темная',
          ),
          _ThemeButton(
            onPressed: () => theme.setThemeMode(ThemeMode.system),
            isOn: theme.theme.mode == ThemeMode.system,
            text: 'Системная',
          ),
        ],
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  const _ThemeButton({
    required this.onPressed,
    required this.isOn,
    required this.text,
  });

  final VoidCallback onPressed;
  final bool isOn;
  final String text;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: standartDuration,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colorScheme.primary.withOpacity(isOn ? 1 : .1),
            ),
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(text),
        ),
      );
}
