import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/common/widgets/file/file_widget.dart';
import 'package:insight/src/common/widgets/file/file_placeholder.dart';
import 'package:insight/src/common/widgets/insight_list_tile.dart';
import 'package:insight/src/common/widgets/shimmer.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight/src/features/profile/bloc/profile_state.dart';

/// {@template profile_widget}
/// ProfileWidget widget.
/// {@endtemplate}
class ProfileWidget extends StatelessWidget {
  /// {@macro profile_widget}
  const ProfileWidget({
    super.key,
    required this.onPressed,
    required this.onEditPressed,
  });

  final VoidCallback onPressed;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (!state.hasData) {
          return const _BodySkeleton();
        }

        final user = state.data!;
        return InsightListTile(
          backgroundColor: context.colorScheme.surfaceContainerHigh,
          onTap: onPressed,
          leadingSize: 48,
          leading: AnimatedSwitcher(
            duration: standartDuration,
            child: user.avatarUrl.isNotNull
                ? CustomImageWidget(
                    user.avatarUrl!,
                    shape: BoxShape.circle,
                  )
                : const FilePlaceholder.rounded(
                    type: FileType.image,
                  ),
          ),
          title: Text(
            user.fullName,
            style: context.textTheme.titleLarge,
          ),
          subtitle: Text(
            user.email,
            style: context.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w300),
          ),
          trailing: AdaptiveButton(
            padding: EdgeInsets.zero,
            onPressed: onEditPressed,
            child: Icon(
              isNeedCupertino ? CupertinoIcons.pencil : Icons.edit,
            ),
          ),
        );
      },
    );
  }
}

class _BodySkeleton extends StatelessWidget {
  const _BodySkeleton();

  @override
  Widget build(BuildContext context) => const Row(
        children: [
          Shimmer(size: Size(60, 60), cornerRadius: 100),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer(size: Size(128, 28)),
              SizedBox(height: 8),
              Shimmer(size: Size(144, 24)),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: null,
            icon: Icon(Icons.edit),
          )
        ],
      );
}
