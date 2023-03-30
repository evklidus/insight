import 'package:flutter/material.dart';

class InsightNavigationBarItem extends StatefulWidget {
  const InsightNavigationBarItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onTap,
    required this.currentIndex,
    required this.itemIndex,
    Key? key,
  }) : super(key: key);

  final Widget activeIcon;
  final Widget inactiveIcon;
  final int currentIndex;
  final int itemIndex;
  final void Function(int) onTap;

  @override
  State<InsightNavigationBarItem> createState() =>
      _InsightNavigationBarItemState();
}

class _InsightNavigationBarItemState extends State<InsightNavigationBarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(widget.itemIndex),
      child: widget.currentIndex == widget.itemIndex
          ? widget.activeIcon
          : widget.inactiveIcon,
    );
  }
}
