import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CloseIcon extends StatelessWidget {
  const CloseIcon(this.onPressed, {Key? key}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final width = 36.w;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10.r,
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Text(
          String.fromCharCode(CupertinoIcons.xmark.codePoint),
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            fontFamily: CupertinoIcons.xmark.fontFamily,
            package: CupertinoIcons.xmark.fontPackage,
          ),
        ),
      ),
    );
  }
}
