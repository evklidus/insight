import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/widgets/information_widget.dart';

class WidgetSwitcher extends StatefulWidget {
  const WidgetSwitcher({
    super.key,
    required this.state,
    this.refresh,
    this.padding = const EdgeInsets.all(16),
    this.duration = standartDuration,
    this.skeletonBuilder,
    required this.childBuilder,
  });

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

  @override
  State<WidgetSwitcher> createState() => _WidgetSwitcherState();
}

class _WidgetSwitcherState extends State<WidgetSwitcher> {
  // final _refreshController = StreamController<SwipeRefreshState>.broadcast();

  Future<void> _onRefresh() async {
    await widget.refresh?.call();

    // _refreshController.sink.add(SwipeRefreshState.hidden);
  }

  @override
  // void dispose() {
  //   _refreshController.close();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final child = switch (widget.state) {
      (hasData: false, isProcessing: _, hasError: true) =>
        InformationWidget.error(reloadFunc: widget.refresh),
      (hasData: false, isProcessing: _, hasError: false) =>
        widget.skeletonBuilder?.call(context) ??
            const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
      _ => widget.childBuilder.call(context),
    };
    final animatedSwitcher = AnimatedSwitcher(
      duration: widget.duration,
      child: child,
    );
    if (widget.padding != EdgeInsets.zero) {
      return Padding(
        padding: widget.padding,
        child: animatedSwitcher,
      );
    }
    // else if (widget.refresh != null) {
    //   return SwipeRefresh.adaptive(
    //     physics: NeverScrollableScrollPhysics(),
    //     shrinkWrap: true,
    //     onRefresh: _onRefresh,
    //     stateStream: _refreshController.stream,
    //     children: [
    //       animatedSwitcher,
    //     ],
    //   );
    // }
    else {
      return animatedSwitcher;
    }
  }
}
