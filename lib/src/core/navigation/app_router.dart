import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
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
import 'package:insight_player/insight_player.dart';

const _defaultFadeTransitionDuration = Duration(milliseconds: 200);

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
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
                name: 'categories',
                path: '/',
                builder: (context, state) => const CategoriesScreen(),
                routes: [
                  // Курсы определенной категории
                  GoRoute(
                    name: 'courses',
                    path: 'courses/:tag',
                    builder: (context, state) => CoursesScreen(
                      state.pathParameters['tag'] as String,
                    ),
                    routes: [
                      GoRoute(
                        name: 'page',
                        path: ':coursePageId',
                        builder: (context, state) => CoursePageScreen(
                          coursePageId:
                              state.pathParameters['coursePageId'].toString(),
                          refreshCoursesList: state.extra as VoidCallback?,
                        ),
                        routes: [
                          // Video
                          GoRoute(
                            name: 'video',
                            path: 'video/:coursePageTitle',
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) => InsightPlayer(
                              videoUrl: state.uri.queryParameters['videoUrl']
                                  as String,
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
                  // Создание курса
                  GoRoute(
                    name: 'create',
                    path: 'create',
                    builder: (context, state) => const CreateCourseScreen(),
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
                  // Auth
                  GoRoute(
                    name: 'login',
                    path: 'login',
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
                    name: 'register',
                    path: 'register',
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
                    name: 'profile',
                    path: 'profile',
                    builder: (context, state) => ProfileScreen(
                      isEditing:
                          state.uri.queryParameters['isEditing'] == 'true',
                    ),
                  ),

                  // About
                  GoRoute(
                    name: 'about',
                    path: 'about',
                    builder: (context, state) => const AppAboutScreen(),
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
