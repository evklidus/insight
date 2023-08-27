import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/custom_snackbar.dart';

import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
import 'package:insight/src/features/auth/bloc/auth_bloc.dart';
import 'package:insight/src/features/auth/widget/components/auth_button.dart';
import 'package:insight/src/features/auth/widget/components/change_auth_type_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) => state.mapOrNull(
        successful: (state) {
          context.go('/login');
          CustomSnackBar.showSuccessful(context, message: state.message);
        },
        error: (state) =>
            CustomSnackBar.showError(context, message: state.message),
      ),
      child: Scaffold(
        body: Form(
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
                  hintText: AppStrings.login,
                  onChanged: (value) => username = value,
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
                child: CustomTextField.password(
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
                        authBloc.add(
                          AuthEvent.register(
                            username: username!,
                            password: password!,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ChangeAuthTypeButton(
                    title: AppStrings.haveAnAccount,
                    subTitle: AppStrings.comeIn,
                    onPressed: () => context.go('/login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
