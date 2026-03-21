import 'package:flutter/material.dart';
import 'package:flutter_bounce_widget/flutter_bounce_widget.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';

enum InputType {
  basic,
  email,
  newPassword,
  password,
  firstName,
  lastName,
  username,
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    TextEditingController? controller,
    int? maxLines,
    String? hintText,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    InputType type = InputType.basic,
  })  : _hintText = hintText,
        _controller = controller,
        _maxLines = maxLines,
        _onChanged = onChanged,
        _validator = validator,
        _type = type;

  const CustomTextField.newPassword({
    super.key,
    TextEditingController? controller,
    int? maxLines,
    String? hintText,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  })  : _hintText = hintText ?? AppStrings.password,
        _controller = controller,
        _maxLines = maxLines,
        _onChanged = onChanged,
        _validator = validator,
        _type = InputType.newPassword;

  const CustomTextField.password({
    super.key,
    TextEditingController? controller,
    int? maxLines,
    String? hintText,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  })  : _hintText = hintText ?? AppStrings.password,
        _controller = controller,
        _maxLines = maxLines,
        _onChanged = onChanged,
        _validator = validator,
        _type = InputType.password;

  final TextEditingController? _controller;
  final int? _maxLines;
  final String? _hintText;
  final void Function(String)? _onChanged;
  final String? Function(String?)? _validator;
  final InputType _type;

  bool get _isForPassword =>
      _type == InputType.password || _type == InputType.newPassword;

  @override
  Widget build(BuildContext context) {
    final textCapitalization = switch (_type) {
      InputType.firstName => TextCapitalization.words,
      InputType.lastName => TextCapitalization.words,
      InputType.basic => TextCapitalization.sentences,
      _ => TextCapitalization.none,
    };
    final autofillHints = switch (_type) {
      InputType.email => [AutofillHints.email],
      InputType.newPassword => [AutofillHints.newPassword],
      InputType.password => [AutofillHints.password],
      InputType.firstName => [AutofillHints.name],
      InputType.lastName => [AutofillHints.familyName],
      InputType.username => [AutofillHints.username],
      InputType.basic => null,
    };
    final keyboardType = switch (_type) {
      InputType.email => TextInputType.emailAddress,
      InputType.newPassword => TextInputType.visiblePassword,
      InputType.password => TextInputType.visiblePassword,
      InputType.firstName => TextInputType.name,
      InputType.lastName => TextInputType.name,
      _ => TextInputType.text,
    };

    if (!_isForPassword) {
      return TextFormField(
        controller: _controller,
        maxLines: _maxLines,
        onChanged: _onChanged,
        validator: _validator,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          fillColor: context.colorScheme.surfaceContainer,
          filled: true,
          hintText: _hintText,
        ),
        textCapitalization: textCapitalization,
        autofillHints: autofillHints,
        keyboardType: keyboardType,
      );
    }

    return _PasswordTextField(
      controller: _controller,
      hintText: _hintText,
      onChanged: _onChanged,
      validator: _validator,
      textCapitalization: textCapitalization,
      autofillHints: autofillHints,
      keyboardType: keyboardType,
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    this.controller,
    this.hintText,
    this.onChanged,
    this.validator,
    required this.textCapitalization,
    required this.autofillHints,
    required this.keyboardType,
  });

  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final TextInputType keyboardType;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  late final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);

  @override
  void dispose() {
    _isPasswordVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPasswordVisible,
      builder: (context, isPasswordVisible, child) {
        return TextFormField(
          controller: widget.controller,
          maxLines: 1,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
            fillColor: context.colorScheme.surfaceContainer,
            filled: true,
            hintText: widget.hintText,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 56,
              minHeight: 56,
            ),
            suffixIcon: _PasswordVisibilityButton(
              isPasswordVisible: isPasswordVisible,
              onTap: () => _isPasswordVisible.value = !isPasswordVisible,
            ),
          ),
          obscureText: !isPasswordVisible,
          enableSuggestions: false,
          autocorrect: false,
          textCapitalization: widget.textCapitalization,
          autofillHints: widget.autofillHints,
          keyboardType: widget.keyboardType,
        );
      },
    );
  }
}

class _PasswordVisibilityButton extends StatelessWidget {
  const _PasswordVisibilityButton({
    required this.isPasswordVisible,
    required this.onTap,
  });

  final bool isPasswordVisible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return SizedBox(
      width: 56,
      height: 56,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Semantics(
          button: true,
          label: isPasswordVisible ? 'Скрыть пароль' : 'Показать пароль',
          child: BounceWidget(
            onPressed: onTap,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isPasswordVisible
                      ? colorScheme.primary.withValues(alpha: 0.12)
                      : colorScheme.onSurface.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.82,
                          end: 1,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    isPasswordVisible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    key: ValueKey(isPasswordVisible),
                    color: isPasswordVisible
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Если вдруг почему-то нужен будет CupertinoTextFormFieldRow:
// isNeedCupertino
//         ? CupertinoTextFormFieldRow(
//             controller: _controller,
//             maxLines: _maxLines,
//             onChanged: _onChanged,
//             validator: _validator,
//             placeholder: _hintText,
//             textCapitalization: textCapitalization,
//             autofillHints: autofillHints,
//             keyboardType: keyboardType,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: context.colorScheme.surfaceContainer,
//             ),
//             padding: EdgeInsets.zero,
//             placeholderStyle: context.textTheme.bodySmall,
//             style: context.textTheme.bodyLarge,
//           )
//         :
