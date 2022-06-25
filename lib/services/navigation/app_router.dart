import 'package:auto_route/auto_route.dart';
import 'package:m_sport/components/screens/internet_warning.dart';
import 'package:m_sport/components/screens/root_screen.dart';
import 'package:m_sport/components/screens/settings_screen.dart';
import 'package:m_sport/features/program_page/presentation/screens/loaded/training_screen.dart';
import 'package:m_sport/features/program_page/presentation/screens/loaded/program_page_screen.dart';
import 'package:m_sport/features/programs/presentation/screens/loaded/programs_screen.dart';
import 'package:flutter/material.dart';
import 'package:m_sport/services/navigation/guards/internet_guard.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';

part 'app_router.gr.dart';

@CupertinoAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: RootScreen,
      initial: true,
      children: [
        AutoRoute(page: ProgramsScreen, initial: true),
        AutoRoute(page: SettingsScreen),
      ],
    ),
    AutoRoute(
      page: ProgramPageScreen,
      guards: [InternetGuard],
    ),
    CustomRoute(
      page: InternetWarningScreen,
      transitionsBuilder: TransitionsBuilders.slideBottom,
      durationInMilliseconds: 300,
    ),
    CustomRoute(
      page: TrainingScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 250,
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter({required InternetGuard internetGuard}) : super(internetGuard: internetGuard);
}
