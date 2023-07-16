import 'package:flutter/material.dart';

import 'package:insight/common/widgets/rounded_back_button.dart';
import 'package:insight/common/widgets/boxes/w_box.dart';

class InsightAppBarWithBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  const InsightAppBarWithBackButton(
    this.title, {
    Key? key,
    this.onTap,
  }) : super(key: key);

  final String title;
  final Function? onTap;

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
          const WBox(15),
          Text(title),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
