import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedBackButton extends StatelessWidget {
  const RoundedBackButton({Key? key, this.onTap}) : super(key: key);

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call() ?? context.popRoute(),
      child: Container(
        height: 40.w,
        width: 40.w,
        margin: EdgeInsets.only(right: 1.w),
        padding: EdgeInsets.symmetric(
          vertical: 8.w,
          horizontal: 5.h,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
        ),
        child: const FittedBox(
          fit: BoxFit.cover,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
    );
  }
}
