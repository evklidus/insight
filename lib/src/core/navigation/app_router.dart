import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:insight/src/common/widgets/root_screen.dart';
import 'package:insight/src/features/auth/widget/screens/login_screen.dart';
import 'package:insight/src/features/auth/widget/screens/register_screen.dart';
import 'package:insight/src/features/categories/widget/screens/categories_screen.dart';
import 'package:insight/src/features/course/widget/screens/create_course_screen.dart';
import 'package:insight/src/features/course_page/widget/screens/course_page_screen.dart';
import 'package:insight/src/features/course/widget/screens/courses_screen.dart';
import 'package:insight/src/features/profile/widget/screens/profile_screen.dart';
import 'package:insight/src/features/settings/widget/screens/app_about_screen.dart';
import 'package:insight/src/features/settings/widget/screens/settings_screen.dart';
import 'package:insight/src/common/widgets/insight_player_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: RootRoute.page,
          initial: true,
          children: [
            // Home aka categories
            _homeRoute,
            _settingsRoute,
          ],
        ),
        AutoRoute(
          path: '/video',
          page: InsightPlayerRoute.page,
        ),
      ];

  final _homeRoute = AutoRoute(
    page: HomeTabRoute.page,
    children: [
      AutoRoute(
        page: CategoriesRoute.page,
        initial: true,
        path: 'categories',
      ),
      // Курсы определенной категории
      AutoRoute(
        path: 'courses',
        page: CoursesRoute.page,
      ),
      AutoRoute(
        path: 'course-page',
        page: CoursePageRoute.page,
      ),
      // Создание курса
      AutoRoute(
        path: 'create',
        page: CreateCourseRoute.page,
      ),
    ],
  );

  final _settingsRoute = AutoRoute(
    page: SettingsTabRoute.page,
    children: [
      AutoRoute(
        initial: true,
        path: 'settings',
        page: SettingsRoute.page,
      ),
      // Авторизация
      AutoRoute(
        path: 'login',
        page: LoginRoute.page,
      ),
      // Регистрация
      AutoRoute(
        path: 'register',
        page: RegisterRoute.page,
      ),
      // Профиль
      AutoRoute(
        path: 'profile',
        page: ProfileRoute.page,
      ),
      // О программе
      AutoRoute(
        path: 'about',
        page: AppAboutRoute.page,
      ),
    ],
  );
}

@RoutePage(name: 'HomeTabRoute')
class HomeTab extends AutoRouter {
  const HomeTab({super.key});
}

@RoutePage(name: 'SettingsTabRoute')
class SettingsTab extends AutoRouter {
  const SettingsTab({super.key});
}
