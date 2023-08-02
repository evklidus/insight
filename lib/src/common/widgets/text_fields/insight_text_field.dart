import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/app_strings.dart';

class InsightTextField extends StatelessWidget {
  const InsightTextField({
    super.key,
    String? hintText,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  })  : _hintText = hintText,
        _onChanged = onChanged,
        _validator = validator,
        _isForPassword = false;

  const InsightTextField.password({
    super.key,
    String? hintText,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  })  : _hintText = hintText ?? AppStrings.password,
        _onChanged = onChanged,
        _validator = validator,
        _isForPassword = true;

  final String? _hintText;
  final void Function(String)? _onChanged;
  final String? Function(String?)? _validator;
  final bool _isForPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: _onChanged,
      validator: _validator,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
        hintText: _hintText,
      ),
      obscureText: _isForPassword,
      enableSuggestions: !_isForPassword,
      autocorrect: !_isForPassword,
    );
  }
}
