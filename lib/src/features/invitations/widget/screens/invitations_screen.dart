import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/app_bars/custom_sliver_app_bar.dart';
import 'package:insight/src/common/widgets/custom_android_refresh_indicator.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/common/widgets/insight_list_tile.dart';
import 'package:insight/src/common/widgets/separated_column.dart';
import 'package:insight/src/common/widgets/shimmer.dart';
import 'package:insight/src/common/widgets/widget_switcher.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/invitations/bloc/invitations_bloc.dart';
import 'package:insight/src/features/invitations/bloc/invitations_state.dart';
import 'package:insight/src/features/invitations/model/user_invitation.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight_snackbar/insight_snackbar.dart';

class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({super.key});

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  late final InvitationsBloc _invitationsBloc;
  String? _acceptingInvitationId;

  @override
  void initState() {
    super.initState();
    _invitationsBloc = InvitationsBloc(
      repository: DIContainer.instance.invitationsRepository,
    )..add(const InvitationsEvent.fetch());
  }

  Future<void> _onRefresh() async {
    _invitationsBloc.add(const InvitationsEvent.fetch());
    await _invitationsBloc.stream.first;
  }

  Future<void> _onAcceptInvitation(
    BuildContext context,
    UserInvitation invitation,
  ) async {
    if (_acceptingInvitationId != null) return;
    setState(() => _acceptingInvitationId = invitation.id);
    try {
      await DIContainer.instance.invitationsRepository
          .acceptInvitation(invitation.id);
      if (!context.mounted) return;
      InsightSnackBar.showSuccessful(
        context,
        text: AppStrings.invitationAcceptedSuccess,
      );
      _invitationsBloc.add(const InvitationsEvent.fetch());
    } on Object catch (e) {
      if (!context.mounted) return;
      InsightSnackBar.showError(context, text: e.toString());
    } finally {
      if (mounted) setState(() => _acceptingInvitationId = null);
    }
  }

  void _onNavigateToCourse(BuildContext context, String courseId) =>
      context.pushNamed(
        RouteKeys.coursePage.name,
        pathParameters: {'coursePageId': courseId},
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _invitationsBloc,
      child: BlocConsumer<InvitationsBloc, InvitationsState>(
        listenWhen: (prev, curr) => curr.hasError && !prev.hasError,
        listener: (context, state) => InsightSnackBar.showError(
          context,
          text: state.message ?? AppStrings.somethingWrong,
        ),
        builder: (context, state) => CustomAndroidRefreshIndicator(
          onRefresh: _onRefresh,
          child: AdaptiveScaffold(
            body: CustomScrollView(
              slivers: [
                const CustomSliverAppBar(
                  title: AppStrings.myInvitations,
                  previousPageTitle: AppStrings.settings,
                ),
                CupertinoSliverRefreshControl(onRefresh: _onRefresh),
                BlocBuilder<InvitationsBloc, InvitationsState>(
                  buildWhen: (prev, curr) => prev != curr,
                  builder: (context, state) => WidgetSwitcher.sliver(
                    state: (
                      hasData: state.hasData,
                      isProcessing: state.isProcessing,
                      hasError: state.hasError,
                    ),
                    skeletonBuilder: (context) => SliverToBoxAdapter(
                      child: SeparatedColumn(
                        itemCount: 3,
                        itemBuilder: (context, index) => const Shimmer(
                          size: Size.fromHeight(72),
                          cornerRadius: 24,
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                      ),
                    ),
                    refresh: _onRefresh,
                    childBuilder: (context) => state.invitations.isEmpty
                        ? SliverToBoxAdapter(
                            child: InformationWidget.empty(
                              title: AppStrings.noInvitations,
                              description: AppStrings.noInvitationsDescription,
                              reloadFunc: null,
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final invitation = state.invitations[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _InvitationTile(
                                    invitation: invitation,
                                    isAccepting:
                                        _acceptingInvitationId == invitation.id,
                                    onAccept: () => _onAcceptInvitation(
                                        context, invitation),
                                    onNavigate: () => _onNavigateToCourse(
                                      context,
                                      invitation.courseId,
                                    ),
                                  ),
                                );
                              },
                              childCount: state.invitations.length,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InvitationTile extends StatelessWidget {
  const _InvitationTile({
    required this.invitation,
    required this.onAccept,
    required this.onNavigate,
    this.isAccepting = false,
  });

  final UserInvitation invitation;
  final VoidCallback onAccept;
  final VoidCallback onNavigate;
  final bool isAccepting;

  @override
  Widget build(BuildContext context) {
    final statusText = invitation.isAccepted
        ? AppStrings.invitationAccepted
        : AppStrings.invitationPending;
    final trailing = invitation.isAccepted
        ? Icon(
            isNeedCupertino
                ? CupertinoIcons.chevron_right
                : Icons.chevron_right,
            color: context.colorScheme.onSurfaceVariant,
          )
        : AdaptiveButton(
            onPressed: isAccepting ? null : onAccept,
            padding: EdgeInsets.fromLTRB(16, 8, isAccepting ? 16 : 0, 8),
            child: isAccepting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                  )
                : const Text(AppStrings.accept),
          );
    return InsightListTile(
      onTap: invitation.isAccepted ? onNavigate : null,
      title: Text(
        invitation.courseName,
        style: context.textTheme.titleMedium,
      ),
      subtitle: Text(
        statusText,
        style: context.textTheme.bodySmall?.copyWith(
          color: invitation.isAccepted
              ? context.colorScheme.primary
              : context.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: trailing,
    );
  }
}
