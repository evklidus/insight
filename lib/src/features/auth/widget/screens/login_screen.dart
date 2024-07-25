import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/features/auth/widget/auth_scope.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
import 'package:insight/src/features/auth/widget/components/auth_button.dart';
import 'package:insight/src/features/auth/widget/components/change_auth_type_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;

  String? password;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authScope = AuthScope.of(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              AppStrings.authorization,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                type: InputType.email,
                hintText: AppStrings.login,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterSomething;
                  }
                  email = value;
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField.password(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterSomething;
                  }
                  password = value;
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            AuthButton(
              title: AppStrings.signIn,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  authScope.login(
                    email: email!,
                    password: password!,
                    onSuccess: (message) {
                      context.go(RouteKeys.categories.path);
                      context.read<ProfileBloc>().add(
                            const ProfileEvent.fetch(),
                          );
                      InsightSnackBar.showSuccessful(context, text: message);
                    },
                    onError: (message) =>
                        InsightSnackBar.showError(context, text: message),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            ChangeAuthTypeButton(
              title: AppStrings.dontHaveAnAccount,
              subTitle: AppStrings.register,
              onPressed: () => context.goRelativeNamed(RouteKeys.register.path),
            ),
          ],
        ),
      ),
    );
  }
}
