import 'package:go_router/go_router.dart';
import 'package:insight/src/common/widgets/screens/insight_bottom_navigation_bar.dart';
import 'package:insight/src/features/categories/widget/screens/main/categories_screen.dart';
import 'package:insight/src/features/course_page/widget/screens/main/course_page_screen.dart';
import 'package:insight/src/features/course_previews/widget/screens/main/course_previews_screen.dart';
import 'package:insight/src/features/profile/widget/screens/profile_screen.dart';
import 'package:insight/src/features/settings/widget/screens/settings_screen.dart';
import 'package:insight_player/insight_player.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: '/categories',
    routes: [
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
                    name: 'previews',
                    path: 'course-previews/:tag',
                    builder: (context, state) => CoursePreviewsScreen(
                      state.pathParameters['tag'] as String,
                    ),
                    routes: [
                      GoRoute(
                        name: 'page',
                        path: 'course-page/:coursePageId',
                        builder: (context, state) => CoursePageScreen(
                          coursePageId: int.parse(
                            state.pathParameters['coursePageId'] as String,
                          ),
                          // TODO: Убрать extra
                          coursePageTitle: state.extra as String,
                        ),
                        routes: [
                          GoRoute(
                            name: 'video',
                            path: 'video/:coursePageTitle',
                            builder: (context, state) => InsightPlayer(
                              // TODO: Убрать extra
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
