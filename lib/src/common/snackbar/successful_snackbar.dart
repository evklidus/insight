import 'package:flutter/material.dart';

/// Снекбар успеха
class SuccessfulSnackBar extends SnackBar {
  /// Отобразить снекбар с ошибкой
  static void show(
    final BuildContext context, {
    final String? message,
  }) =>
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SuccessfulSnackBar(
          message: message,
        ),
      );

  // TODO: Добавить анимацию
  SuccessfulSnackBar({
    String? message,
    Key? key,
  }) : super(
          key: key,
          backgroundColor: Colors.greenAccent,
          content: SizedBox(
            height: 48,
            child: Center(
              child: Text(
                message ?? 'Successful',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // TODO: Вынести в отдельный файл констант
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
