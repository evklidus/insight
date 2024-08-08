import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight/src/common/widgets/buttons/cancel_button.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/profile/bloc/nickname/nickname_bloc.dart';
import 'package:insight/src/features/profile/bloc/nickname/nickname_state.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight_snackbar/insight_snackbar.dart';

/// {@template change_nickname}
/// ChangeNickname widget.
/// {@endtemplate}
class ChangeNickname extends StatefulWidget {
  /// {@macro change_nickname}
  const ChangeNickname(this.nickname, {super.key});

  final String? nickname;

  @override
  State<ChangeNickname> createState() => _ChangeNicknameState();
}

/// State for widget ChangeNickname.
class _ChangeNicknameState extends State<ChangeNickname> {
  late final NicknameBloc _nicknameBloc;
  late final TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _nicknameBloc = NicknameBloc(
      repository: DIContainer.instance.profileRepository,
      initialState: NicknameState.idle(data: widget.nickname),
    );
    _nicknameController = TextEditingController(text: widget.nickname);
  }

  @override
  void dispose() {
    _nicknameBloc.close();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final boldStyle = DefaultTextStyle.of(context).style.copyWith(
          fontWeight: FontWeight.bold,
        );

    return BlocBuilder<NicknameBloc, NicknameState>(
      bloc: _nicknameBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CancelButton(onPressed: () => Navigator.of(context).pop()),
                AnimatedSwitcher(
                  duration: standartDuration,
                  key: ValueKey(state.isProcessing),
                  child: state.isProcessing
                      ? const CircularProgressIndicator.adaptive()
                      : AdaptiveButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            final trimmedText = _nicknameController.text.trim();
                            final username =
                                trimmedText.isNotEmpty ? trimmedText : null;
                            final isUsernameChanged =
                                username != widget.nickname;

                            if (isUsernameChanged) {
                              final usernameRegExp =
                                  RegExp(r"^[a-zA-Z][a-zA-Z0-9_]*?$");
                              if (username.isNotNull) {
                                if (!usernameRegExp.hasMatch(username!)) {
                                  return InsightSnackBar.showError(
                                    context,
                                    text:
                                        'Имя пользователя не может содержать пробелов или начинаться с цифр',
                                    bottomPadding:
                                        MediaQuery.viewInsetsOf(context)
                                            .bottom
                                            .toInt(),
                                  );
                                }
                              }
                              _nicknameBloc.add(
                                NicknameEvent.save(
                                  newNickname: username,
                                  oldNickname: widget.nickname,
                                  onSuccess: () {
                                    Navigator.of(context).pop();
                                    BlocProvider.of<ProfileBloc>(context).add(
                                      const ProfileEvent.fetch(),
                                    );
                                  },
                                  // TODO: Получать text из state
                                  onError: () => InsightSnackBar.showError(
                                    context,
                                    text: 'Это имя пользователя уже занято',
                                  ),
                                ),
                              );
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(AppStrings.done),
                        ),
                ),
              ],
            ),
            SizedBox(height: screenSize.shortestSide * .1),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                'Имя пользователя',
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.textTheme.labelLarge?.color?.withOpacity(0.8),
                ),
              ),
            ),
            CustomTextField(
              controller: _nicknameController,
              type: InputType.username,
            ),
            const SizedBox(height: 20),
            const Text(
              'Имя пользяователя является публичным. Пока используется для развлечения 🙃',
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                text: 'Имя пользователя может состоять из ',
                children: [
                  TextSpan(
                    text: 'а-z',
                    style: boldStyle,
                  ),
                  const TextSpan(text: ', '),
                  TextSpan(
                    text: '0-9',
                    style: boldStyle,
                  ),
                  const TextSpan(text: ' и '),
                  TextSpan(
                    text: '_',
                    style: boldStyle,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
