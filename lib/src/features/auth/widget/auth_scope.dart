import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/auth/bloc/auth_bloc.dart';

///
abstract mixin class AuthenticationController {
  void checkStatus();

  void register({
    required String email,
    required String password,
    void Function(String message)? onSuccess,
    void Function(String message)? onError,
  });

  void login({
    required String email,
    required String password,
    void Function(String message)? onSuccess,
    void Function(String message)? onError,
  });

  void logout();

  bool get isAuthenticated;
}

///
class AuthScope extends StatefulWidget {
  const AuthScope(this.child, {super.key});

  ///
  final Widget child;

  ////
  static AuthenticationController of(
    BuildContext context, {
    bool listen = true,
  }) =>
      context.inhOf<_InheritedAuthentication>(listen: listen).controller;

  @override
  State<AuthScope> createState() => _AuthScopeState();
}

class _AuthScopeState extends State<AuthScope> with AuthenticationController {
  late final AuthBloc _authBloc;

  AuthState? _state;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(
      repository: DIContainer.instance.authRepository,
    );
    _authBloc.add(const AuthEvent.checkStatus());
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
        bloc: _authBloc,
        builder: (context, state) {
          _state = state;
          return _InheritedAuthentication(
            controller: this,
            state: _state,
            child: widget.child,
          );
        },
      );

  @override
  void checkStatus() => _authBloc.add(const AuthEvent.checkStatus());

  @override
  bool get isAuthenticated => _authBloc.state.isAuthenticated ?? false;

  @override
  void login({
    required String email,
    required String password,
    void Function(String message)? onSuccess,
    void Function(String message)? onError,
  }) =>
      _authBloc.add(
        AuthEvent.login(
          username: email,
          password: password,
          onSuccess: onSuccess,
          onError: onError,
        ),
      );

  @override
  void logout() => _authBloc.add(const AuthEvent.logout());

  @override
  void register({
    required String email,
    required String password,
    void Function(String message)? onSuccess,
    void Function(String message)? onError,
  }) =>
      _authBloc.add(
        AuthEvent.register(
          username: email,
          password: password,
          onSuccess: onSuccess,
          onError: onError,
        ),
      );
}

///
class _InheritedAuthentication extends InheritedWidget {
  const _InheritedAuthentication({
    required this.controller,
    required this.state,
    required super.child,
  });

  ///
  final AuthState? state;

  ///
  final AuthenticationController controller;

  @override
  bool updateShouldNotify(_InheritedAuthentication oldWidget) =>
      state != oldWidget.state;
}
