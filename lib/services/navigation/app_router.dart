import 'package:auto_route/auto_route.dart';
import 'package:insight/components/screens/internet_warning_screen.dart';
import 'package:insight/components/screens/root_screen.dart';
import 'package:insight/components/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:insight/features/course_page/presentation/screens/main/program_page_screen.dart';
import 'package:insight/features/course_page/presentation/screens/main/training_screen.dart';
import 'package:insight/features/courses_preview/presentation/screens/main/programs_screen.dart';
import 'package:insight/services/navigation/guards/internet_guard.dart';
import 'package:insight/features/courses_preview/domain/entities/course_preview_entity.dart';

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
  AppRouter({required InternetGuard internetGuard})
      : super(internetGuard: internetGuard);
}
