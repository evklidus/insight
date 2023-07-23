import 'package:auto_route/auto_route.dart';
import 'package:insight/src/common/widgets/screens/root_screen.dart';
import 'package:flutter/material.dart';
// import 'package:insight/src/features/auth/widget/screens/main/auth_screen.dart';
import 'package:insight/src/features/categories/widget/screens/main/categories_screen.dart';
import 'package:insight/src/features/course_page/widget/screens/main/course_page_screen.dart';
import 'package:insight/src/features/course_previews/widget/screens/main/course_previews_screen.dart';
import 'package:insight/src/features/profile/widget/screens/main/profile_screen.dart';
import 'package:insight/src/features/settings/widget/screens/settings_screen.dart';
import 'package:insight_player/insight_player.dart';

part 'app_router.gr.dart';

@CupertinoAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    // AutoRoute(page: AuthScreen),
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
    AutoRoute(
      page: ProfileScreen,
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter() : super();
}