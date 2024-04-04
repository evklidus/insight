import 'package:flutter/material.dart';
import 'package:insight/src/common/widgets/navigation_bars/custom_navigation_bar_item.dart';
import 'package:insight/gen/assets.gen.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({
    required this.onTap,
    required this.currentIndex,
    super.key,
  });

  final void Function(int) onTap;
  final int currentIndex;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <CustomNavigationBarItem>[
              CustomNavigationBarItem(
                activeIcon: Assets.icons.insightFilledBottomBarIcon.svg(),
                inactiveIcon: Assets.icons.insightSolidBottomBarIcon.svg(),
                onTap: widget.onTap,
                currentIndex: widget.currentIndex,
                itemIndex: 0,
              ),
              CustomNavigationBarItem(
                activeIcon: Assets.icons.gearshapeFilledBottomBarIcon.svg(),
                inactiveIcon: Assets.icons.gearshapeSolidBottomBarIcon.svg(),
                onTap: widget.onTap,
                currentIndex: widget.currentIndex,
                itemIndex: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
