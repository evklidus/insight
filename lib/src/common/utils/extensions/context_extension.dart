import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';

extension BuildContextX on BuildContext {
  /// Returns [ColorScheme] from [BuildContext]
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns [TextTheme] from [BuildContext].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Use onle with [CustomAppBar]
  EdgeInsets get adaptiveScreenPadding => isNeedCupertino
      ? EdgeInsets.symmetric(
          horizontal: 16,
          vertical: MediaQuery.paddingOf(this).vertical / 2,
        )
      : const EdgeInsets.all(16);

  /// Obtain the nearest widget of the given type T,
  /// which must be the type of a concrete [InheritedWidget] subclass,
  /// and register this build context with that widget such that
  /// when that widget changes (or a new widget of that type is introduced,
  /// or the widget goes away), this build context is rebuilt so that it can
  /// obtain new values from that widget.
  T? inhMaybeOf<T extends InheritedWidget>({bool listen = true}) => listen
      ? dependOnInheritedWidgetOfExactType<T>()
      : getInheritedWidgetOfExactType<T>();

  /// Obtain the nearest widget of the given type T,
  /// which must be the type of a concrete [InheritedWidget] subclass,
  /// and register this build context with that widget such that
  /// when that widget changes (or a new widget of that type is introduced,
  /// or the widget goes away), this build context is rebuilt so that it can
  /// obtain new values from that widget.
  T inhOf<T extends InheritedWidget>({bool listen = true}) =>
      inhMaybeOf<T>(listen: listen) ??
      (throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a $T of the exact type',
        'out_of_scope',
      ));

  /// Maybe inherit specific aspect from [InheritedModel].
  T? maybeInheritFrom<A extends Object, T extends InheritedModel<A>>(
    A? aspect,
  ) =>
      InheritedModel.inheritFrom<T>(this, aspect: aspect);

  /// Inherit specific aspect from [InheritedModel].
  T inheritFrom<A extends Object, T extends InheritedModel<A>>({A? aspect}) =>
      InheritedModel.inheritFrom<T>(this, aspect: aspect) ??
      (throw ArgumentError(
        'Out of scope, not found inherited model '
            'a $T of the exact type',
        'out_of_scope',
      ));
}
