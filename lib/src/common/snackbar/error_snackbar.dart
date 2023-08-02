import 'package:flutter/material.dart';

/// Снекбар ошибки
class ErrorSnackBar extends SnackBar {
  /// Отобразить снекбар с ошибкой
  static void show(
    final BuildContext context, {
    final String? error,
  }) =>
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        ErrorSnackBar(
          error: error,
          context: context,
        ),
      );

  // TODO: Добавить анимацию
  ErrorSnackBar({
    String? error,
    required BuildContext context,
    Key? key,
  }) : super(
          key: key,
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Center(
            child: Text(
              error ?? 'Произошла ошибка',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
}
