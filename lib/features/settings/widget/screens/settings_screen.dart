import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/common/constants/app_strings.dart';
import 'package:insight/features/auth/bloc/auth_bloc.dart';
import 'package:insight/features/settings/widget/components/setting_row.dart';

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
            SettingRow(
              title: AppStrings.exit,
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
              ),
              onTap: () => authBloc.add(const AuthEvent.logout()),
            ),
          ],
        ),
      ),
    );
  }
}
