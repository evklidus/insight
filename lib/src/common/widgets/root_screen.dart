import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';

@RoutePage()
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(context) {
    return AutoTabsRouter(
      transitionBuilder: (context, child, _) => child,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return isNeedCupertino
            ? CupertinoTabScaffold(
                key: UniqueKey(),
                tabBar: CupertinoTabBar(
                  currentIndex: tabsRouter.activeIndex,
                  onTap: (tappedIndex) =>
                      tabsRouter.setActiveIndex(tappedIndex),
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
                  builder: (context) => child,
                ),
              )
            : Scaffold(
                body: child,
                bottomNavigationBar: NavigationBar(
                  selectedIndex: tabsRouter.activeIndex,
                  onDestinationSelected: (tappedIndex) =>
                      tabsRouter.setActiveIndex(tappedIndex),
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
      },
    );
  }
}
