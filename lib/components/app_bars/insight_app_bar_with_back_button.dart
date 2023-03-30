import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/components/rounded_back_icon.dart';
import 'package:insight/components/boxes/w_box.dart';

class InsightAppBarWithBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  const InsightAppBarWithBackButton(this.title, {Key? key, this.onTap})
      : super(key: key);

  final String title;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.h, top: kToolbarHeight, bottom: 5.h),
      child: Row(
        children: [
          RoundedBackIcon(
            onTap: onTap,
          ),
          WBox(15.w),
          Hero(
            tag: title,
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 180.w,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
