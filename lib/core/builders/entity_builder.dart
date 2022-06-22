import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:m_sport/core/stores/entity_store.dart';
import 'package:provider/provider.dart';

class EntityBuilder<T extends EntityStore> extends StatelessWidget {
  const EntityBuilder({
    Key? key,
    required this.loadedWidget,
    required this.loadingWidget,
    required this.failureWidget,
    this.emptyWidget,
  }) : super(key: key);

  final Widget loadedWidget;
  final Widget loadingWidget;
  final Widget failureWidget;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final store = context.read<T>();
      if (store.loaded) {
        return loadedWidget;
      }
      if (store.loading) {
        return loadingWidget;
      }
      if (store.failure) {
        return failureWidget;
      }
      if (store.empty && emptyWidget != null) {
        return emptyWidget!;
      }
      return loadingWidget;
    });
  }
}
