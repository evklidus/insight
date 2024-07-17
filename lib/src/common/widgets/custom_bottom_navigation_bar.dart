import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar(this.navigationShell, {super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(context) {
    return isNeedCupertino
        ? CupertinoTabScaffold(
            key: UniqueKey(),
            tabBar: CupertinoTabBar(
              currentIndex: widget.navigationShell.currentIndex,
              onTap: (tappedIndex) =>
                  widget.navigationShell.goBranch(tappedIndex),
              items: const [
                BottomNavigationBarItem(
                  activeIcon: Icon(CupertinoIcons.house_fill),
                  icon: Icon(CupertinoIcons.house),
                  label: AppStrings.main,
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(CupertinoIcons.settings_solid),
                  icon: Icon(CupertinoIcons.settings),
                  label: AppStrings.settings,
                ),
              ],
            ),
            tabBuilder: (context, index) => CupertinoTabView(
              builder: (context) => widget.navigationShell,
            ),
          )
        : Scaffold(
            body: widget.navigationShell,
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (tappedIndex) =>
                  widget.navigationShell.goBranch(tappedIndex),
              selectedIndex: widget.navigationShell.currentIndex,
              destinations: const [
                NavigationDestination(
                  selectedIcon: Icon(Icons.home_filled),
                  icon: Icon(Icons.home_outlined),
                  label: AppStrings.main,
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.settings),
                  icon: Icon(Icons.settings_outlined),
                  label: AppStrings.settings,
                )
              ],
            ),
          );
  }
}
