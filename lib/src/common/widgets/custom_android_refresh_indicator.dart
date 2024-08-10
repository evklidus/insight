import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';

/// Адаптивный индикатор обновления. Использовать совместоно с adaptiveScrollPhysics
class CustomAndroidRefreshIndicator extends StatelessWidget {
  const CustomAndroidRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return isNeedCupertino
        ? child
        : RefreshIndicator(
            onRefresh: onRefresh,
            child: child,
          );
  }
}
