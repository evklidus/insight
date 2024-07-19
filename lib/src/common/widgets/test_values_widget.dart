import 'package:flutter/widgets.dart';
import 'package:insight/gen/pubspec.yaml.g.dart';
import 'package:insight/src/common/utils/build_mode.dart';
import 'package:insight/src/common/utils/current_flavor.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';

class TestValues extends StatelessWidget {
  const TestValues({super.key});

  @override
  Widget build(BuildContext context) {
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
    return RichText(
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
    );
  }
}
