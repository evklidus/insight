import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/current_flavor.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';

import 'package:insight/src/features/auth/bloc/auth_bloc.dart';
import 'package:insight/src/features/settings/widget/components/setting_row.dart';

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
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 30,
        ),
        child: Column(
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return _authBloc.state.isAuthenticated!
                    ? SettingRow(
                        title: AppStrings.signOut,
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.redAccent,
                        ),
                        onTap: () {
                          _authBloc.add(const AuthEvent.logout());
                          context.go('/login');
                        },
                      )
                    : SettingRow(
                        title: AppStrings.signIn,
                        icon: Icon(
                          Icons.login_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onTap: () => context.go('/login'),
                      );
              },
            ),
            if (_authBloc.state.isAuthenticated!) ...[
              const SizedBox(height: 20),
              // Profile
              SettingRow(
                title: AppStrings.profile,
                icon: const Icon(Icons.person_2_rounded),
                onTap: () => context.goRelativeNamed('profile'),
              ),
            ],
            if (!Flavor.isProd)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(Flavor.current),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
