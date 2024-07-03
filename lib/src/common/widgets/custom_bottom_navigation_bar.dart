import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight_snackbar/common/platform_helpers.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar(this.navigationShell, {super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: isNeedCupertino
          ? CupertinoTabBar(
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
            )
          : NavigationBar(
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
