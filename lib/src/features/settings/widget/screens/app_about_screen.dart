import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insight/gen/assets.gen.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/gen/pubspec.yaml.g.dart';
import 'package:insight/src/common/widgets/test_values_widget.dart';
import 'package:flutter_bounce_widget/flutter_bounce_widget.dart';

/// {@template app_about_screen}
/// AppAboutScreen widget.
/// {@endtemplate}
class AppAboutScreen extends StatefulWidget {
  /// {@macro app_about_screen}
  const AppAboutScreen({super.key});

  @override
  State<AppAboutScreen> createState() => _AppAboutScreenState();
}

class _AppAboutScreenState extends State<AppAboutScreen> {
  int _imageTapCount = 0;
  final _maxTapCountToShowTestValues = 10;

  bool isNeedToShowTestValues = false;

  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.sizeOf(context).height / 4;

    return AdaptiveScaffold(
      appBar: const CustomAppBar(
        title: 'О приложении',
        previousPageTitle: AppStrings.settings,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(height: 32),
              BounceWidget(
                onPressed: () {
                  _imageTapCount++;
                  HapticFeedback.lightImpact();
                  if (_imageTapCount >= _maxTapCountToShowTestValues) {
                    isNeedToShowTestValues = true;
                    setState(() {});
                  }
                },
                child: Image.asset(
                  Assets.images.insightAppLogo.keyName,
                  height: imageHeight,
                  width: imageHeight,
                ),
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
              const SizedBox(height: 24),
              AnimatedOpacity(
                opacity: isNeedToShowTestValues ? 1 : 0,
                duration: standartDuration,
                child: const TestValues(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
