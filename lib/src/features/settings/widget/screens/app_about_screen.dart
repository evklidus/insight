import 'package:flutter/material.dart';
import 'package:insight/gen/assets.gen.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/current_flavor.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';

/// {@template app_about_screen}
/// AppAboutScreen widget.
/// {@endtemplate}
class AppAboutScreen extends StatelessWidget {
  /// {@macro app_about_screen}
  const AppAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.sizeOf(context).height / 4;

    return Scaffold(
      appBar: const CustomAppBar('О приложении'),
      body: Center(
        child: Column(
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
            // TODO: Показывать версию приложения
            Text(
              'Версия: ',
              style: context.textTheme.titleLarge,
            ),
            const Spacer(),
            Text(
              'flavor: ${Flavor.current}',
              style: context.textTheme.titleLarge,
            ),
            SizedBox(height: MediaQuery.viewPaddingOf(context).bottom),
          ],
        ),
      ),
    );
  }
}
