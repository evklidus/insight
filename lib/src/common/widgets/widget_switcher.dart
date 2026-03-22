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
    this.switchDelay = const Duration(milliseconds: 180),
    this.skeletonBuilder,
    required this.childBuilder,
  }) : _isForSliver = false;

  const WidgetSwitcher.sliver({
    super.key,
    required this.state,
    this.refresh,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 0),
    this.duration = standartDuration,
    this.switchDelay = const Duration(milliseconds: 180),
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
  final Duration switchDelay;
  final Widget Function(BuildContext context)? skeletonBuilder;
  final Widget Function(BuildContext context) childBuilder;

  final bool _isForSliver;

  @override
  State<WidgetSwitcher> createState() => _WidgetSwitcherState();
}

enum _WidgetSwitcherView { error, skeleton, empty, content }

class _WidgetSwitcherState extends State<WidgetSwitcher> {
  late _WidgetSwitcherView _view;
  Timer? _switchTimer;
  bool _hasSeenProcessing = false;
  bool _canShowEmpty = false;

  @override
  void initState() {
    super.initState();
    _syncProgressFlags();
    _view = _resolveView();
  }

  @override
  void didUpdateWidget(covariant WidgetSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncProgressFlags();

    final targetView = _resolveView();
    if (_view == targetView) {
      _switchTimer?.cancel();
      _switchTimer = null;
      return;
    }

    _switchTimer?.cancel();
    if (widget.switchDelay == Duration.zero) {
      setState(() => _view = targetView);
      return;
    }

    _switchTimer = Timer(
      widget.switchDelay,
      () {
        if (!mounted) return;

        final currentView = _resolveView();
        if (currentView != targetView) {
          return;
        }

        setState(() => _view = targetView);
      },
    );
  }

  void _syncProgressFlags() {
    _hasSeenProcessing = _hasSeenProcessing || widget.state.isProcessing;
    _canShowEmpty = _canShowEmpty ||
        widget.state.hasData ||
        widget.state.hasError ||
        (_hasSeenProcessing && !widget.state.isProcessing);
  }

  _WidgetSwitcherView _resolveView() => switch (widget.state) {
        (hasData: false, isProcessing: _, hasError: true) =>
          _WidgetSwitcherView.error,
        (hasData: false, isProcessing: true, hasError: false) =>
          _WidgetSwitcherView.skeleton,
        (hasData: false, isProcessing: false, hasError: false) => _canShowEmpty
            ? _WidgetSwitcherView.empty
            : _WidgetSwitcherView.skeleton,
        _ => _WidgetSwitcherView.content,
      };

  @override
  void dispose() {
    _switchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = switch (_view) {
      _WidgetSwitcherView.error => widget._isForSliver
          ? SliverToBoxAdapter(
              child: InformationWidget.error(reloadFunc: widget.refresh),
            )
          : InformationWidget.error(reloadFunc: widget.refresh),
      _WidgetSwitcherView.skeleton => widget.skeletonBuilder?.call(context) ??
          (
            widget._isForSliver
                ? const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  )
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
          ) as Widget,
      _WidgetSwitcherView.empty => widget.childBuilder.call(context),
      _WidgetSwitcherView.content => widget.childBuilder.call(context),
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
        child: KeyedSubtree(
          key: ValueKey(_view),
          child: paddedWidget,
        ),
      );
    }
  }
}
