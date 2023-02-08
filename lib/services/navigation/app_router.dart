import 'package:auto_route/auto_route.dart';
import 'package:insight/components/screens/internet_warning_screen.dart';
import 'package:insight/components/screens/root_screen.dart';
import 'package:insight/components/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:insight/features/categories/presentation/screens/main/categories_screen.dart';
import 'package:insight/features/course_page/presentation/screens/main/course_page_screen.dart';
import 'package:insight/features/course_page/presentation/screens/main/lesson_screen.dart';
import 'package:insight/features/courses_previews/presentation/screens/main/course_previews_screen.dart';
import 'package:insight/services/navigation/guards/internet_guard.dart';

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
      guards: [InternetGuard],
    ),
    AutoRoute(
      page: CoursePageScreen,
      guards: [InternetGuard],
    ),
    AutoRoute(
      page: LessonScreen,
      guards: [InternetGuard],
    ),
    CustomRoute(
      page: InternetWarningScreen,
      transitionsBuilder: TransitionsBuilders.slideBottom,
      durationInMilliseconds: 300,
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter({
    required InternetGuard internetGuard,
  }) : super(internetGuard: internetGuard);
}
