import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/widgets/navigation_bars/custom_navigation_bar.dart';

class InsightBottomNavigationBar extends StatelessWidget {
  const InsightBottomNavigationBar(this.navigationShell, {Key? key})
      : super(key: key);

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (int tappedIndex) {
          navigationShell.goBranch(tappedIndex);
        },
      ),
    );
  }
}
