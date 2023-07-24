import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';
import 'package:insight/src/common/widgets/boxes/h_box.dart';
import 'package:insight/src/features/auth/bloc/auth_bloc.dart';
import 'package:insight/src/features/settings/widget/components/setting_row.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
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
            // Sign Out
            SettingRow(
              title: AppStrings.exit,
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
              ),
              onTap: () => authBloc.add(const AuthEvent.logout()),
            ),
            const HBox(20),
            // Profile
            SettingRow(
              title: AppStrings.profile,
              icon: const Icon(
                Icons.person_2_rounded,
                color: Colors.blueGrey,
              ),
              onTap: () => context.goRelativeNamed('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
