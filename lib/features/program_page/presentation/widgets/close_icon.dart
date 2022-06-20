import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CloseIcon extends StatelessWidget {
  const CloseIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.router.pop,
      child: const Icon(
        CupertinoIcons.clear_circled_solid,
        color: Colors.grey,
      ),
    );
  }
}
