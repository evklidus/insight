import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:insight/components/navigation_bars/insight_navigation_bar_item.dart';
import 'package:insight/gen/assets.gen.dart';

class InsightNavigationBar extends StatefulWidget {
  const InsightNavigationBar({
    required this.onTap,
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  final void Function(int) onTap;
  final int currentIndex;

  @override
  State<InsightNavigationBar> createState() => _InsightNavigationBarState();
}

class _InsightNavigationBarState extends State<InsightNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <InsightNavigationBarItem>[
          InsightNavigationBarItem(
            activeIcon: Assets.icons.insightFilledBottomBarIcon.svg(),
            inactiveIcon: Assets.icons.insightSolidBottomBarIcon.svg(),
            onTap: widget.onTap,
            currentIndex: widget.currentIndex,
            itemIndex: 0,
          ),
          InsightNavigationBarItem(
            activeIcon: Assets.icons.gearshapeFilledBottomBarIcon.svg(),
            inactiveIcon: Assets.icons.gearshapeSolidBottomBarIcon.svg(),
            onTap: widget.onTap,
            currentIndex: widget.currentIndex,
            itemIndex: 1,
          ),
        ],
      ),
    ).asGlass(
      frosted: false,
      tintColor: Colors.black,
      blurX: 30,
      blurY: 30,
    );
  }
}
