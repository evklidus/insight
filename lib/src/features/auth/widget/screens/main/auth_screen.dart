import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/common/widgets/loadings/standart_loading.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/auth/bloc/auth_bloc.dart';
import 'package:insight/src/features/auth/widget/screens/states/login_screen.dart';
import 'package:insight/src/features/auth/widget/screens/states/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen(this.child, {super.key});

  final Widget child;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(DIContainer().authRepository);
    authBloc.add(const AuthEvent.checkStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => authBloc,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => state.when(
            idle: () => InformationWidget.idle(),
            loading: () => const StandartLoading(),
            register: () => const RegisterScreen(),
            login: () => const LoginScreen(),
            authorized: () => widget.child,
            error: (errorMsg) => InformationWidget.error(
              reloadFunc: () => authBloc.add(
                const AuthEvent.checkStatus(),
              ),
              description: errorMsg,
            ),
          ),
        ),
      ),
    );
  }
}
