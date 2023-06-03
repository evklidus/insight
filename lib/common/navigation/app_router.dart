import 'package:auto_route/auto_route.dart';
import 'package:insight/common/widgets/screens/root_screen.dart';
import 'package:insight/common/widgets/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:insight/features/categories/presentation/screens/main/categories_screen.dart';
import 'package:insight/features/course_page/presentation/screens/main/course_page_screen.dart';
import 'package:insight/features/course_previews/presentation/screens/main/course_previews_screen.dart';
import 'package:insight_player/insight_player.dart';

part 'app_router.gr.dart';

@CupertinoAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: RootScreen,
      initial: true,
      children: [
        AutoRoute(page: CategoriesScreen, initial: true),
        AutoRoute(page: SettingsScreen),
      ],
    ),
    AutoRoute(
      page: CoursePreviewsScreen,
    ),
    AutoRoute(
      page: CoursePageScreen,
    ),
    AutoRoute(
      name: 'InsightPlayerRoute',
      page: InsightPlayer,
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter() : super();
}
