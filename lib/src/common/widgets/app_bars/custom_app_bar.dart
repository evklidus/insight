import 'package:flutter/material.dart';

import 'package:insight/src/common/widgets/rounded_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
    this.leadingText, {
    super.key,
    this.onTap,
  });

  final String? leadingText;
  final Function? onTap;

  bool get _hasLeadingText => leadingText != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        top: kToolbarHeight,
        bottom: 5,
      ),
      child: Row(
        children: [
          RoundedBackButton(
            onTap: onTap,
          ),
          if (_hasLeadingText) const SizedBox(width: 15),
          if (_hasLeadingText) Text(leadingText!),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
