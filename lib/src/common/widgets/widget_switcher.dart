import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/widgets/information_widget.dart';

class WidgetSwitcher extends StatelessWidget {
  const WidgetSwitcher({
    super.key,
    required this.state,
    this.refresh,
    this.skeletonBuilder,
    required this.childBuilder,
  });

  final ({
    bool hasData,
    bool isProcessing,
    bool hasError,
  }) state;
  final VoidCallback? refresh;
  final Widget Function(BuildContext context)? skeletonBuilder;
  final Widget Function(BuildContext context) childBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: standartDuration,
      child: switch (state) {
        (hasData: false, isProcessing: _, hasError: true) =>
          InformationWidget.error(reloadFunc: refresh),
        (hasData: false, isProcessing: _, hasError: false) =>
          skeletonBuilder?.call(context) ??
              const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
        _ => childBuilder.call(context),
      },
    );
  }
}
