import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';

/// {@template adaptive_scaffold}
/// AdaptiveScaffold widget.
/// {@endtemplate}
class AdaptiveScaffold extends StatelessWidget {
  /// {@macro adaptive_scaffold}
  const AdaptiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
  });

  final CustomAppBar? appBar;
  final Widget body;

  /// NavigationBar for android
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) => isNeedCupertino
      ? CupertinoPageScaffold(
          navigationBar: appBar,
          child: body,
        )
      : Scaffold(
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
        );
}
