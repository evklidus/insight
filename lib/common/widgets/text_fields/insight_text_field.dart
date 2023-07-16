import 'package:flutter/material.dart';

class InsightTextField extends StatelessWidget {
  const InsightTextField({
    super.key,
    this.hintText,
    this.onChanged,
    this.validator,
    this.width,
  });

  final String? hintText;
  final void Function(String)? onChanged;
  final double? width;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: width,
        child: TextFormField(
          onChanged: onChanged,
          validator: validator,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.black54,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
