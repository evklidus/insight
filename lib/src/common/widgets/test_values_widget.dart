import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:insight/gen/pubspec.yaml.g.dart';
import 'package:insight/src/common/utils/build_mode.dart';
import 'package:insight/src/common/utils/current_flavor.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:provider/provider.dart';

class TestValues extends StatelessWidget {
  const TestValues({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = Provider.of<ProfileBloc>(context);
    final userId = profileBloc.state.data?.id ?? 'ID отсутствует';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _TestValueText(title: 'flavor', value: Flavor.current),
          _TestValueText(title: 'build mode', value: BuildMode.current),
          _TestValueText(
            title: 'version',
            value: Pubspec.version.representation,
          ),
          const SizedBox(height: 8),
          _TestValueText(
            title: 'User ID',
            value: userId,
          ),
        ],
      ),
    );
  }
}

class _TestValueText extends StatelessWidget {
  const _TestValueText({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        InsightSnackBar.showInfo(
          context,
          text: 'Значение скопировано',
        );
        HapticFeedback.selectionClick();
      },
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: RichText(
          maxLines: 5,
          text: TextSpan(
            text: '$title: ',
            children: <TextSpan>[
              TextSpan(
                text: value,
                style: DefaultTextStyle.of(context).style.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
