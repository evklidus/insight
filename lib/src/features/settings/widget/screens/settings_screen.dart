import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/utils/current_flavor.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/common/widgets/test_values_widget.dart';
import 'package:insight/src/features/auth/widget/auth_scope.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight/src/features/settings/widget/components/profile_widget.dart';
import 'package:insight/src/features/settings/widget/components/setting_row.dart';
import 'package:insight/src/features/settings/widget/components/theme_change_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authScope = AuthScope.of(context);

    return AdaptiveScaffold(
      appBar: const CustomAppBar(
        title: AppStrings.settings,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.paddingOf(context).bottom,
        ),
        child: ListView(
          children: [
            AnimatedSwitcher(
              duration: standartDuration,
              child: authScope.isAuthenticated
                  ? ProfileWidget(
                      onPressed: () =>
                          context.goRelativeNamed(RouteKeys.profile.name),
                      onEditPressed: () => context.goRelativeNamed(
                        RouteKeys.profile.name,
                        queryParams: {'isEditing': 'true'},
                      ),
                    )
                  : SettingRow(
                      title: AppStrings.signIn,
                      icon: Icon(
                        isNeedCupertino
                            ? CupertinoIcons.person_fill
                            : Icons.login_rounded,
                      ),
                      onTap: () =>
                          context.goRelativeNamed(RouteKeys.login.name),
                    ),
            ),
            const SizedBox(height: 20),
            // Theme
            const ThemeChangeWidget(),
            AnimatedSwitcher(
              duration: standartDuration,
              child: authScope.isAuthenticated
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SettingRow(
                        title: 'Мои курсы',
                        icon: Icon(
                          isNeedCupertino
                              ? CupertinoIcons.person_solid
                              : Icons.person,
                        ),
                        onTap: () =>
                            context.goRelativeNamed(RouteKeys.userCourses.name),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            // About app
            SettingRow(
              title: 'О приложении',
              icon: Icon(
                isNeedCupertino
                    ? CupertinoIcons.info_circle_fill
                    : Icons.info_rounded,
              ),
              onTap: () => context.goRelativeNamed('about'),
            ),
            const SizedBox(height: 20),
            if (!Flavor.isProd) const TestValues(),
            const SizedBox(height: 20),
            if (authScope.isAuthenticated)
              AdaptiveButton(
                onPressed: () {
                  authScope.logout();
                  context.read<ProfileBloc>().add(
                        const ProfileEvent.clear(),
                      );
                },
                child: const Text(AppStrings.signOut),
              ),
          ],
        ),
      ),
    );
  }
}
