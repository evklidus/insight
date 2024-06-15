import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';

/// {@template whole_screen_loading_indicator}
/// WholeScreenLoadingIndicator widget.
/// {@endtemplate}
class WholeScreenLoadingIndicator extends StatelessWidget {
  /// {@macro whole_screen_loading_indicator}
  const WholeScreenLoadingIndicator({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          IgnorePointer(
            ignoring: !isLoading,
            child: AnimatedOpacity(
              opacity: isLoading ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: context.colorScheme.onSurface.withOpacity(.7),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: context.colorScheme.surface,
                      ),
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: context.colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
}
