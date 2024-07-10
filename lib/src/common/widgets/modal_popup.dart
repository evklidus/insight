import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/src/common/utils/extensions/context_extension.dart';

/// Stylized modal popup.
///
/// Intended to be displayed with the [show] method.
abstract class ModalPopup {
  /// Returns a padding that should be applied to the elements inside a
  /// [ModalPopup].
  static EdgeInsets padding(BuildContext context) =>
      const EdgeInsets.symmetric(horizontal: 30);

  /// Opens a new [ModalPopup] wrapping the provided [child].
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    AnimationController? transitionAnimationController,
    EdgeInsets mobilePadding = const EdgeInsets.fromLTRB(16, 16, 16, 0),
    EdgeInsets desktopPadding = const EdgeInsets.all(10),
    bool isDismissible = true,
    bool showDivider = true,
    bool useRootNavigator = false,
  }) {
    if (!kIsWeb) {
      return showModalBottomSheet(
        useRootNavigator: useRootNavigator,
        context: context,
        transitionAnimationController: transitionAnimationController,
        isScrollControlled: true,
        isDismissible: isDismissible,
        enableDrag: isDismissible,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height - kToolbarHeight,
        ),
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            if (isDismissible && showDivider) ...[
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: context.colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: Padding(
                padding: mobilePadding,
                child: child,
              ),
            ),
            SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
          ],
        ),
      );
    } else {
      return showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (context) {
          return Center(child: child);
        },
      );
    }
  }
}

/// [Row] with [text] and [WidgetButton] stylized to be a [ModalPopup] header.
class ModalPopupHeader extends StatelessWidget {
  const ModalPopupHeader({
    super.key,
    this.text,
    this.onBack,
    this.close = true,
  });

  /// Text to display as a title of this [ModalPopupHeader].
  final String? text;

  /// Callback, called when a back button is pressed.
  ///
  /// If `null`, then no back button is displayed at all.
  final void Function()? onBack;

  /// Indicator whether a close button should be displayed.
  final bool close;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Row(
        children: [
          if (onBack != null)
            WidgetButton(
              onPressed: onBack,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 14,
                  color: context.colorScheme.primary,
                ),
              ),
            )
          else
            const SizedBox(width: 40),
          if (text != null)
            Expanded(
              child: Center(
                child: Text(text!, style: context.textTheme.titleLarge),
              ),
            )
          else
            const Spacer(),
          if (kIsWeb && close)
            WidgetButton(
              onPressed: Navigator.of(context).pop,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: context.colorScheme.primary,
                ),
              ),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}

/// Simple [GestureDetector]-based button without any decorations.
class WidgetButton extends StatelessWidget {
  const WidgetButton({
    super.key,
    required this.child,
    this.behavior,
    this.onPressed,
  });

  /// [Widget] to press.
  final Widget child;

  /// [HitTestBehavior] of this [WidgetButton].
  final HitTestBehavior? behavior;

  /// Callback, called when the [child] is pressed.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onPressed == null ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        behavior: behavior,
        child: Container(
          color: context.colorScheme.scrim,
          child: child,
        ),
      ),
    );
  }
}
