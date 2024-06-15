import 'package:flutter/material.dart';
import 'package:insight/src/common/widgets/shimmer.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Shimmer(
            size: Size(200, 200),
            cornerRadius: 100,
          ),
          const SizedBox(height: 20),
          const Shimmer(),
          const SizedBox(height: 10),
          Shimmer(
            size: Size(width / 2, 30),
          ),
        ],
      ),
    );
  }
}
