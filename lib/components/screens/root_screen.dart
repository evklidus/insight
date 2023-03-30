import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:insight/components/navigation_bars/insight_navigation_bar.dart';
import 'package:insight/services/navigation/app_router.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return AutoTabsScaffold(
      extendBody: true,
      routes: const [
        CategoriesRoute(),
        SettingsRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) => InsightNavigationBar(
        currentIndex: tabsRouter.activeIndex,
        onTap: tabsRouter.setActiveIndex,
      ),
    );
  }
}
