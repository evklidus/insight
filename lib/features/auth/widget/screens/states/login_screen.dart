import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/common/constants/app_strings.dart';
import 'package:insight/common/widgets/boxes/h_box.dart';
import 'package:insight/common/widgets/insight_text_field.dart';
import 'package:insight/features/auth/bloc/auth_bloc.dart';
import 'package:insight/features/auth/widget/components/auth_button.dart';
import 'package:insight/features/auth/widget/components/change_auth_type_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  String? username;

  String? password;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            AppStrings.authorization,
            style: TextStyle(fontSize: 20),
          ),
          const HBox(50),
          InsightTextField(
            hintText: AppStrings.login,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.pleaseEnterSomething;
              }
              username = value;
              return null;
            },
          ),
          const HBox(20),
          InsightTextField(
            hintText: AppStrings.password,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.pleaseEnterSomething;
              }
              password = value;
              return null;
            },
          ),
          const HBox(20),
          AuthButton(
            title: AppStrings.comeIn,
            onTap: () {
              if (formKey.currentState!.validate()) {
                authBloc.add(
                  AuthEvent.login(
                    username: username!,
                    password: password!,
                  ),
                );
              }
            },
          ),
          const HBox(20),
          ChangeAuthTypeButton(
            title: AppStrings.dontHaveAnAccount,
            subTitle: AppStrings.register,
            onPressed: () =>
                authBloc.add(const AuthEvent.changeAuthTypeToRegister()),
          ),
        ],
      ),
    );
  }
}
