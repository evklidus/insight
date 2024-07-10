import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/app_strings.dart';

enum InputType { basic, email, newPassword, password, firstName, lastName }

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    TextEditingController? controller,
    String? hintText,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    InputType type = InputType.basic,
  })  : _hintText = hintText,
        _controller = controller,
        _onChanged = onChanged,
        _validator = validator,
        _type = type;

  const CustomTextField.newPassword({
    super.key,
    TextEditingController? controller,
    String? hintText,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  })  : _hintText = hintText ?? AppStrings.password,
        _controller = controller,
        _onChanged = onChanged,
        _validator = validator,
        _type = InputType.newPassword;

  const CustomTextField.password({
    super.key,
    TextEditingController? controller,
    String? hintText,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  })  : _hintText = hintText ?? AppStrings.password,
        _controller = controller,
        _onChanged = onChanged,
        _validator = validator,
        _type = InputType.password;

  final TextEditingController? _controller;
  final String? _hintText;
  final void Function(String)? _onChanged;
  final String? Function(String?)? _validator;
  final InputType _type;

  bool get _isForPassword => _type == InputType.password;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: _onChanged,
      validator: _validator,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        filled: true,
        hintText: _hintText,
      ),
      textCapitalization: switch (_type) {
        InputType.firstName => TextCapitalization.words,
        InputType.lastName => TextCapitalization.words,
        InputType.basic => TextCapitalization.sentences,
        _ => TextCapitalization.none,
      },
      obscureText: _isForPassword,
      enableSuggestions: !_isForPassword,
      autocorrect: !_isForPassword,
      autofillHints: switch (_type) {
        InputType.email => [AutofillHints.email],
        InputType.newPassword => [AutofillHints.newPassword],
        InputType.password => [AutofillHints.password],
        InputType.firstName => [AutofillHints.name],
        InputType.lastName => [AutofillHints.familyName],
        InputType.basic => null,
      },
      keyboardType: switch (_type) {
        InputType.email => TextInputType.emailAddress,
        InputType.newPassword => TextInputType.visiblePassword,
        InputType.password => TextInputType.visiblePassword,
        InputType.firstName => TextInputType.name,
        InputType.lastName => TextInputType.name,
        InputType.basic => TextInputType.text,
      },
    );
  }
}
