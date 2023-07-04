import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CloseIcon extends StatelessWidget {
  const CloseIcon(this.onPressed, {Key? key}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Text(
          String.fromCharCode(CupertinoIcons.xmark.codePoint),
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: CupertinoIcons.xmark.fontFamily,
            package: CupertinoIcons.xmark.fontPackage,
          ),
        ),
      ),
    );
  }
}
