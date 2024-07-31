import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/widgets/root_screen.dart';
import 'package:insight/src/core/player/insight_player.dart';
import 'package:insight/src/features/auth/widget/screens/login_screen.dart';
import 'package:insight/src/features/auth/widget/screens/register_screen.dart';
import 'package:insight/src/features/categories/widget/screens/categories_screen.dart';
import 'package:insight/src/features/course/widget/screens/create_course_screen.dart';
import 'package:insight/src/features/course/widget/screens/user_courses_screen.dart';
import 'package:insight/src/features/course_page/widget/screens/course_page_screen.dart';
import 'package:insight/src/features/course/widget/screens/courses_screen.dart';
import 'package:insight/src/features/profile/widget/screens/profile_screen.dart';
import 'package:insight/src/features/settings/widget/screens/app_about_screen.dart';
import 'package:insight/src/features/settings/widget/screens/settings_screen.dart';

const _defaultFadeTransitionDuration = Duration(milliseconds: 200);

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteKeys.categories.path,
    routes: [
      // Tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            RootScreen(navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              // Категории
              GoRoute(
                name: RouteKeys.categories.name,
                path: RouteKeys.categories.path,
                builder: (context, state) => const CategoriesScreen(),
                routes: [
                  // Курсы определенной категории
                  GoRoute(
                    name: RouteKeys.courses.name,
                    path: RouteKeys.courses.path,
                    builder: (context, state) => CoursesScreen(
                      state.pathParameters['tag'] as String,
                    ),
                  ),
                  // Создание курса
                  GoRoute(
                    name: RouteKeys.create.name,
                    path: RouteKeys.create.path,
                    builder: (context, state) => const CreateCourseScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteKeys.settings.name,
                path: RouteKeys.settings.path,
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  // Auth
                  GoRoute(
                    name: RouteKeys.login.name,
                    path: RouteKeys.login.path,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const LoginScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                      transitionDuration: _defaultFadeTransitionDuration,
                      reverseTransitionDuration: _defaultFadeTransitionDuration,
                    ),
                  ),
                  // Registration
                  GoRoute(
                    name: RouteKeys.register.name,
                    path: RouteKeys.register.path,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const RegisterScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                      transitionDuration: _defaultFadeTransitionDuration,
                      reverseTransitionDuration: _defaultFadeTransitionDuration,
                    ),
                  ),

                  // Profile
                  GoRoute(
                    name: RouteKeys.profile.name,
                    path: RouteKeys.profile.path,
                    builder: (context, state) => ProfileScreen(
                      isEditing:
                          state.uri.queryParameters['isEditing'] == 'true',
                    ),
                  ),

                  // User courses
                  GoRoute(
                    name: RouteKeys.userCourses.name,
                    path: RouteKeys.userCourses.path,
                    builder: (context, state) => const UserCoursesScreen(),
                  ),

                  // About
                  GoRoute(
                    name: RouteKeys.about.name,
                    path: RouteKeys.about.path,
                    builder: (context, state) => const AppAboutScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: RouteKeys.coursePage.name,
        path: RouteKeys.coursePage.path,
        builder: (context, state) => CoursePageScreen(
          coursePageId: state.pathParameters['coursePageId'].toString(),
          refreshCoursesList: state.extra as VoidCallback?,
        ),
      ),
      // Video
      GoRoute(
        name: RouteKeys.video.name,
        path: RouteKeys.video.path,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => InsightPlayer(
          videoUrl: state.uri.queryParameters['videoUrl'] as String,
          title: state.pathParameters['coursePageTitle'] as String,
          onVideoEnd: context.pop,
          onCloseButtonPressed: context.pop,
        ),
      ),
    ],
  );
}
