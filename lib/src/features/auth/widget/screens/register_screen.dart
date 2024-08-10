import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/features/auth/widget/auth_scope.dart';
import 'package:insight_snackbar/insight_snackbar.dart';

import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
import 'package:insight/src/features/auth/widget/components/auth_button.dart';
import 'package:insight/src/features/auth/widget/components/change_auth_type_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email;

  String? password;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authScope = AuthScope.of(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: AutofillGroup(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              AppStrings.registration,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                type: InputType.email,
                hintText: AppStrings.login,
                onChanged: (value) => email = value,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField.newPassword(
                onChanged: (value) => password = value,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthButton(
                  title: AppStrings.register,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      authScope.register(
                        email: email!,
                        password: password!,
                        onSuccess: (message) {
                          context.goRelativeNamed(RouteKeys.login.name);
                          InsightSnackBar.showSuccessful(context,
                              text: message);
                        },
                        onError: (message) =>
                            InsightSnackBar.showError(context, text: message),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                ChangeAuthTypeButton(
                  title: AppStrings.haveAnAccount,
                  subTitle: AppStrings.signIn,
                  onPressed: () =>
                      context.goRelativeNamed(RouteKeys.login.name),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
