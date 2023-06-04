import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.only(
        left: 16.h,
        top: kToolbarHeight,
        bottom: 5.h,
      ),
      child: Row(
        children: [
          RoundedBackButton(
            onTap: onTap,
          ),
          WBox(15.w),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
