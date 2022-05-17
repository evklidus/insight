import 'package:auto_route/auto_route.dart';
import 'package:m_sport/screens/root_screen.dart';
import 'package:m_sport/screens/settings_screen.dart';
import 'package:m_sport/screens/training_programs_list_screen.dart';
import 'package:m_sport/screens/trainings_list_screen.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@CupertinoAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: RootScreen,
      initial: true,
      children: [
        AutoRoute(
          page: EmptyRouterPage,
          name: 'CatalogRoute',
          initial: true,
          children: [
            AutoRoute(page: ProgramsListScreen, initial: true),
            AutoRoute(page: TrainingsListScreen),
          ],
        ),
        AutoRoute(
          page: EmptyRouterPage,
          name: 'MainSettingsRoute',
          initial: true,
          children: [
            AutoRoute(
              page: SettingsScreen,
              initial: true,
            ),
          ],
        ),
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {}
