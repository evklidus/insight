import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/shimmer.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight/src/features/profile/bloc/profile_state.dart';
import 'package:insight/src/features/profile/widget/components/avatar_widget.dart';

/// {@template profile_widget}
/// ProfileWidget widget.
/// {@endtemplate}
class ProfileWidget extends StatefulWidget {
  /// {@macro profile_widget}
  const ProfileWidget({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.mail,
    required this.onPressed,
  });

  final String avatarUrl;
  final String name;
  final String mail;
  final VoidCallback onPressed;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc =
        ProfileBloc(repository: DIContainer.instance.profileRepository)
          ..add(const ProfileEvent.fetch());
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: ShapeDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          builder: (context, state) {
            if (state.hasData) {
              final user = state.data!;
              return Row(
                children: [
                  AvatarWidget(user.avatarUrl, width: 60, height: 60),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.fullName),
                      Text(
                        user.email,
                        style: context.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: widget.onPressed,
                    icon: const Icon(Icons.edit),
                  )
                ],
              );
            }
            return const _BodySkeleton();
          },
        ),
      );
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
