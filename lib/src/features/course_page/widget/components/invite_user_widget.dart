import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight/src/common/widgets/modal_popup.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/course_page/model/invitation.dart';
import 'package:insight_snackbar/insight_snackbar.dart';

/// Bottom sheet для приглашения пользователя на закрытый курс по email или никнейму.
class InviteUserWidget extends StatefulWidget {
  const InviteUserWidget({
    super.key,
    required this.courseId,
    required this.onInviteSent,
  });

  final String courseId;
  final VoidCallback onInviteSent;

  @override
  State<InviteUserWidget> createState() => _InviteUserWidgetState();
}

class _InviteUserWidgetState extends State<InviteUserWidget> {
  String _emailOrNickname = '';
  bool _isLoading = false;
  List<Invitation> _invitations = const [];
  bool _invitationsLoading = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadInvitations();
  }

  Future<void> _loadInvitations() async {
    final invitations = await DIContainer.instance.coursePageRepository
        .getInvitations(widget.courseId);
    if (mounted) {
      setState(() {
        _invitations = invitations;
        _invitationsLoading = false;
      });
    }
  }

  Future<void> _inviteHandler() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom.round() - 20;
    try {
      await DIContainer.instance.coursePageRepository.sendInvitation(
        courseId: widget.courseId,
        emailOrNickname: _emailOrNickname.trim(),
      );

      if (!mounted) return;
      final sent = _emailOrNickname.trim();
      setState(() {
        _invitations = [
          Invitation(
            emailOrNickname: sent,
            status: InvitationStatus.pending,
          ),
          ..._invitations,
        ];
        _emailOrNickname = '';
      });
      _formKey.currentState?.reset();
      widget.onInviteSent();

      InsightSnackBar.showSuccessful(
        context,
        text: AppStrings.invitationSent,
        bottomPadding: bottomPadding,
      );
    } on DioException catch (e) {
      if (!mounted) return;
      if (e.response?.statusCode == 404) {
        InsightSnackBar.showError(
          context,
          text: AppStrings.userNotFound,
          bottomPadding: bottomPadding,
        );
      } else {
        final errMsg = e.response?.data is Map
            ? (e.response!.data as Map)['error']?.toString()
            : null;
        final errLower = errMsg?.toLowerCase() ?? '';
        final isAlreadyInvited =
            errLower.contains('invitation already exists') ||
                errLower.contains('invitation_already_exists');
        InsightSnackBar.showError(
          context,
          text: isAlreadyInvited
              ? AppStrings.invitationAlreadyExists
              : (errMsg ?? e.message ?? e.toString()),
          bottomPadding: bottomPadding,
        );
      }
    } on Object catch (e) {
      if (!mounted) return;
      InsightSnackBar.showError(
        context,
        text: e.toString(),
        bottomPadding: MediaQuery.viewInsetsOf(context).bottom.round(),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ModalPopupHeader(text: AppStrings.inviteUser),
              const SizedBox(height: 24),
              CustomTextField(
                hintText: AppStrings.inviteEmailOrNicknameHint,
                onChanged: (value) => _emailOrNickname = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.pleaseEnterSomething;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              AdaptiveButton.filled(
                onPressed: _isLoading ? null : _inviteHandler,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(AppStrings.invite),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.invitedList,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              _InvitationsList(
                invitations: _invitations,
                isLoading: _invitationsLoading,
              ),
            ],
          ),
        ),
      );
}

class _InvitationsList extends StatelessWidget {
  const _InvitationsList({
    required this.invitations,
    required this.isLoading,
  });

  final List<Invitation> invitations;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: isLoading,
            child: const SizedBox(
              height: 48,
              child: Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isLoading && invitations.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: invitations
                  .map((invitation) => _InvitationTile(invitation: invitation))
                  .toList(),
            ),
          ),
        ],
      );
}

class _InvitationTile extends StatelessWidget {
  const _InvitationTile({required this.invitation});

  final Invitation invitation;

  @override
  Widget build(BuildContext context) {
    final statusText = invitation.isAccepted
        ? AppStrings.invitationAccepted
        : AppStrings.invitationPending;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              invitation.emailOrNickname,
              style: context.textTheme.bodyMedium,
            ),
          ),
          Text(
            statusText,
            style: context.textTheme.bodySmall?.copyWith(
              color: invitation.isAccepted
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
