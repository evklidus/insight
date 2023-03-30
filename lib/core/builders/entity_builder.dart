import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:insight/components/information_widget.dart';
import 'package:insight/components/loadings/standart_loading.dart';
import 'package:insight/core/stores/entity_store.dart';
import 'package:insight/utilities/load_states.dart';
import 'package:provider/provider.dart';

class EntityBuilder<T extends EntityStore> extends StatelessWidget {
  const EntityBuilder({
    Key? key,
    required this.loadedWidget,
    this.loadingWidget,
    this.failureWidget,
    this.emptyWidget,
  }) : super(key: key);

  final Widget loadedWidget;
  final Widget? loadingWidget;
  final Widget? failureWidget;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    final store = context.read<T>();
    return Observer(builder: (context) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.fastOutSlowIn,
        switchOutCurve: Curves.fastOutSlowIn,
        child: () {
          switch (store.loadState) {
            case LoadStates.successful:
              return loadedWidget;
            case LoadStates.loading:
              return loadingWidget ?? const StandartLoading();
            case LoadStates.failed:
              return failureWidget ?? InformationWidget<T>(LoadStates.failed);
            case LoadStates.empty:
              return emptyWidget ?? InformationWidget<T>(LoadStates.empty);
          }
        }.call(),
      );
    });
  }
}
