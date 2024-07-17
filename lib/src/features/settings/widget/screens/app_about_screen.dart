import 'package:flutter/material.dart';
import 'package:insight/gen/assets.gen.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';

import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/gen/pubspec.yaml.g.dart';

/// {@template app_about_screen}
/// AppAboutScreen widget.
/// {@endtemplate}
class AppAboutScreen extends StatelessWidget {
  /// {@macro app_about_screen}
  const AppAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.sizeOf(context).height / 4;

    return AdaptiveScaffold(
      appBar: const CustomAppBar(title: 'О приложении'),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(height: 32),
              Assets.images.insightAppLogo.image(
                height: imageHeight,
                width: imageHeight,
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.appName,
                style: context.textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              Text(
                'Версия: ${Pubspec.version.representation}',
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
