import 'package:flutter/material.dart';
import 'package:insight/common/widgets/boxes/h_box.dart';
import 'package:insight/features/profile/model/user.dart';
import 'package:insight/features/profile/widget/components/avatar_widget.dart';

class ProfileLoadedScreen extends StatefulWidget {
  const ProfileLoadedScreen({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<ProfileLoadedScreen> createState() => _ProfileLoadedScreenState();
}

class _ProfileLoadedScreenState extends State<ProfileLoadedScreen> {
  bool get hasName => widget.user.firstName != null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const HBox(30),
          AvatarWidget(
            widget.user.avatarUrl,
            width: 200,
            height: 200,
          ),
          if (hasName) const HBox(20),
          if (hasName) Text('${widget.user.firstName} ${widget.user.lastName}'),
          const HBox(10),
          Text(
            '@${widget.user.username}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
