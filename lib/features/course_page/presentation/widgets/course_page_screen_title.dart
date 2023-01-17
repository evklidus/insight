import 'package:flutter/material.dart';
import 'package:insight/components/rounded_back_icon.dart';
import 'package:insight/components/boxes/w_box.dart';

class CoursePageScreenTitle extends StatelessWidget {
  const CoursePageScreenTitle(this.courseName, {Key? key, this.onTap})
      : super(key: key);

  final String courseName;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          RoundedBackIcon(
            onTap: () {
              onTap;
            },
          ),
          const WBox(10),
          Hero(
            tag: courseName,
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 180,
                child: Text(
                  courseName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
