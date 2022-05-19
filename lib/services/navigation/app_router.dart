import 'package:auto_route/auto_route.dart';
import 'package:m_sport/screens/internet_warning.dart';
import 'package:m_sport/screens/root_screen.dart';
import 'package:m_sport/screens/settings_screen.dart';
import 'package:m_sport/screens/programs_list_screen.dart';
import 'package:m_sport/screens/trainings_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:m_sport/services/navigation/guards/internet_guard.dart';

part 'app_router.gr.dart';

@CupertinoAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: RootScreen,
      initial: true,
      children: [
        AutoRoute(page: ProgramsListScreen, initial: true),
        AutoRoute(page: SettingsScreen),
      ],
    ),
    AutoRoute(
      page: TrainingsListScreen,
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
  AppRouter({required InternetGuard internetGuard}) : super(internetGuard: internetGuard);
}
