import 'package:flutter/material.dart';

class CustomNavigationBarItem extends StatefulWidget {
  const CustomNavigationBarItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onTap,
    required this.currentIndex,
    required this.itemIndex,
    super.key,
  });

  final Widget activeIcon;
  final Widget inactiveIcon;
  final int currentIndex;
  final int itemIndex;
  final void Function(int) onTap;

  @override
  State<CustomNavigationBarItem> createState() =>
      _CustomNavigationBarItemState();
}

class _CustomNavigationBarItemState extends State<CustomNavigationBarItem> {
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
