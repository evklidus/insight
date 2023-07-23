import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/boxes/h_box.dart';
import 'package:insight/src/common/widgets/text_fields/insight_text_field.dart';
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
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            AppStrings.registration,
            style: TextStyle(fontSize: 20),
          ),
          const HBox(50),
          InsightTextField(
            width: 300,
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
          const HBox(20),
          InsightTextField(
            width: 300,
            hintText: AppStrings.password,
            onChanged: (value) => password = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.pleaseEnterSomething;
              }
              password = value;
              return null;
            },
          ),
          const HBox(20),
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
              const HBox(20),
              ChangeAuthTypeButton(
                title: AppStrings.haveAnAccount,
                subTitle: AppStrings.comeIn,
                onPressed: () =>
                    authBloc.add(const AuthEvent.changeAuthTypeToLogin()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
