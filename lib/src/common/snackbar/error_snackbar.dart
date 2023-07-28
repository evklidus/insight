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
        ),
      );

  ErrorSnackBar({
    final String? error,
    Key? key,
  }) : super(
          key: key,
          backgroundColor: Colors.redAccent,
          content: SizedBox(
            height: 48,
            child: Center(
              child: Text(
                error ?? 'Произошла ошибка',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          duration: const Duration(milliseconds: 6000),
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        );
}
