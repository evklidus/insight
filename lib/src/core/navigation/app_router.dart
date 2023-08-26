import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/widgets/screens/insight_bottom_navigation_bar.dart';
import 'package:insight/src/features/auth/widget/screens/login_screen.dart';
import 'package:insight/src/features/auth/widget/screens/register_screen.dart';
import 'package:insight/src/features/categories/widget/screens/categories_screen.dart';
import 'package:insight/src/features/course_page/widget/screens/course_page_screen.dart';
import 'package:insight/src/features/course/widget/screens/courses_screen.dart';
import 'package:insight/src/features/profile/widget/screens/profile_screen.dart';
import 'package:insight/src/features/settings/widget/screens/settings_screen.dart';
import 'package:insight_player/insight_player.dart';

const _defaultFadeTransitionDuration = Duration(milliseconds: 200);

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/categories',
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: _defaultFadeTransitionDuration,
          reverseTransitionDuration: _defaultFadeTransitionDuration,
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: _defaultFadeTransitionDuration,
          reverseTransitionDuration: _defaultFadeTransitionDuration,
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            InsightBottomNavigationBar(navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                builder: (context, state) => const CategoriesScreen(),
                routes: [
                  GoRoute(
                    name: 'courses',
                    path: 'courses/:tag',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => CoursesScreen(
                      state.pathParameters['tag'] as String,
                    ),
                    routes: [
                      GoRoute(
                        name: 'page',
                        path: 'course-page/:coursePageId',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => CoursePageScreen(
                          coursePageId:
                              state.pathParameters['coursePageId'].toString(),
                        ),
                        routes: [
                          GoRoute(
                            name: 'video',
                            path: 'video/:coursePageTitle',
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) => InsightPlayer(
                              videoUrl: state.extra as String,
                              title: state.pathParameters['coursePageTitle']
                                  as String,
                              onVideoEnd: context.pop,
                              onCloseButtonPressed: context.pop,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    name: 'profile',
                    path: 'profile',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
