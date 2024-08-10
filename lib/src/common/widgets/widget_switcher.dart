import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/widgets/information_widget.dart';

// class SliverWidgetSwitcher extends WidgetSwitcher {
//   factory SliverWidgetSwitcher({
//     Key? key,
//     required ({
//       bool hasData,
//       bool isProcessing,
//       bool hasError,
//     }) state,
//     Future<void> Function()? refresh,
//     EdgeInsets padding,
//     Duration duration,
//     Widget Function(BuildContext context)? skeletonBuilder,
//     required Widget Function(BuildContext context) childBuilder,
//   }) = WidgetSwitcher.sliver;
// }

class WidgetSwitcher extends StatefulWidget {
  const WidgetSwitcher({
    super.key,
    required this.state,
    this.refresh,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 0),
    this.duration = standartDuration,
    this.skeletonBuilder,
    required this.childBuilder,
  }) : _isForSliver = false;

  const WidgetSwitcher.sliver({
    super.key,
    required this.state,
    this.refresh,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 0),
    this.duration = standartDuration,
    this.skeletonBuilder,
    required this.childBuilder,
  }) : _isForSliver = true;

  final ({
    bool hasData,
    bool isProcessing,
    bool hasError,
  }) state;
  final Future<void> Function()? refresh;
  final EdgeInsets padding;
  final Duration duration;
  final Widget Function(BuildContext context)? skeletonBuilder;
  final Widget Function(BuildContext context) childBuilder;

  final bool _isForSliver;

  @override
  State<WidgetSwitcher> createState() => _WidgetSwitcherState();
}

class _WidgetSwitcherState extends State<WidgetSwitcher> {
  @override
  Widget build(BuildContext context) {
    final child = switch (widget.state) {
      (hasData: false, isProcessing: _, hasError: true) => widget._isForSliver
          ? SliverToBoxAdapter(
              child: InformationWidget.error(reloadFunc: widget.refresh),
            )
          : InformationWidget.error(reloadFunc: widget.refresh),
      (hasData: false, isProcessing: _, hasError: false) =>
        widget.skeletonBuilder?.call(context) ??
            (
              widget._isForSliver
                  ? const SliverToBoxAdapter(
                      child:
                          Center(child: CircularProgressIndicator.adaptive()),
                    )
                  : const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
            ) as Widget,
      _ => widget.childBuilder.call(context),
    };

    final paddedWidget = widget._isForSliver
        ? SliverPadding(
            padding: widget.padding,
            sliver: child,
          )
        : Padding(
            padding: widget.padding,
            child: child,
          );

    if (widget._isForSliver) {
      return paddedWidget;
    } else {
      return AnimatedSwitcher(
        duration: widget.duration,
        child: paddedWidget,
      );
    }
  }
}
