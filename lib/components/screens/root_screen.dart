import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:insight/services/navigation/app_router.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return AutoTabsScaffold(
      routes: const [
        CategoriesRoute(),
        SettingsRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Categories',
              icon: Icon(Icons.list_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Posts',
              icon: Icon(Icons.settings),
            ),
          ],
        );
      },
    );
  }
}
