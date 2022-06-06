import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class RoundedBackIcon extends StatelessWidget {
  const RoundedBackIcon({Key? key, this.onTap}) : super(key: key);

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call() ?? context.router.popUntilRoot(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(111, 158, 158, 158),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: const Padding(
            padding: EdgeInsets.only(right: 1),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
