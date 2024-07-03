import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/current_flavor.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';
import 'package:insight/src/common/widgets/adaptive_button.dart';

import 'package:insight/src/features/auth/bloc/auth_bloc.dart';
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
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.settings,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isAuthenticated = _authBloc.state.isAuthenticated!;

            return Column(
              children: [
                AnimatedSwitcher(
                  duration: standartDuration,
                  child: isAuthenticated
                      ? ProfileWidget(
                          onPressed: () => context.goRelativeNamed('profile'),
                          onEditPressed: () => context.goRelativeNamed(
                            'profile',
                            queryParams: {'isEditing': 'true'},
                          ),
                        )
                      : SettingRow(
                          title: AppStrings.signIn,
                          icon: Icon(
                            Icons.login_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onTap: () => context.go('/login'),
                        ),
                ),
                const SizedBox(height: 20),
                // Theme
                const ThemeChangeWidget(),
                const SizedBox(height: 20),
                // About app
                SettingRow(
                  title: 'О приложении',
                  icon: const Icon(Icons.info_rounded),
                  onTap: () => context.goRelativeNamed('about'),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isAuthenticated)
                      AdaptiveButton(
                        onPressed: () {
                          _authBloc.add(const AuthEvent.logout());
                          context.read<ProfileBloc>().add(
                                const ProfileEvent.clear(),
                              );
                          context.go('/login');
                        },
                        child: const Text(AppStrings.signOut),
                      ),
                    if (!Flavor.isProd) Text(Flavor.current),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
