import 'package:flutter/material.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AdaptiveButton.filled(onPressed: onTap, child: Text(title));
  }
}
