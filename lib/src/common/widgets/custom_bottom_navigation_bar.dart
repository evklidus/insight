import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar(this.navigationShell, {super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(context) {
    return Platform.isIOS
        ? CupertinoTabScaffold(
            key: ValueKey(navigationShell.currentIndex),
            tabBar: CupertinoTabBar(
              key: ValueKey(navigationShell.currentIndex),
              currentIndex: navigationShell.currentIndex,
              onTap: (tappedIndex) => navigationShell.goBranch(tappedIndex),
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
            tabBuilder: (BuildContext context, int index) => CupertinoTabView(
              builder: (BuildContext context) => navigationShell,
            ),
          )
        : Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (tappedIndex) =>
                  navigationShell.goBranch(tappedIndex),
              selectedIndex: navigationShell.currentIndex,
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
