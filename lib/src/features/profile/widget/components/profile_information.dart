import 'package:flutter/material.dart';

import 'package:insight/src/features/profile/model/user.dart';
import 'package:insight/src/features/profile/widget/components/avatar_widget.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<ProfileInformation> createState() => _ProfileLoadedScreenState();
}

class _ProfileLoadedScreenState extends State<ProfileInformation> {
  bool get hasName => widget.user.firstName != null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          AvatarWidget(
            widget.user.avatarUrl,
            width: 200,
            height: 200,
          ),
          if (hasName) const SizedBox(height: 20),
          if (hasName) Text('${widget.user.firstName} ${widget.user.lastName}'),
          const SizedBox(height: 10),
          Text(
            '@${widget.user.username}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
