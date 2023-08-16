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
  bool get _hasName => widget.user.firstName != null;
  bool get _hasUsername => widget.user.username != null;
  bool get _hasEmail => widget.user.email != null;

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
          if (_hasName) const SizedBox(height: 20),
          if (_hasName)
            Text('${widget.user.firstName} ${widget.user.lastName}'),
          if (_hasUsername) const SizedBox(height: 10),
          if (_hasUsername)
            Text(
              '@${widget.user.username}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (_hasEmail) const SizedBox(height: 10),
          if (_hasEmail)
            Text(
              widget.user.email!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}
