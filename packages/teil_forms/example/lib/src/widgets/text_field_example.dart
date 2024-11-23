import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

class TextFieldExample extends StatelessWidget {
  final TeilFormField<String?> field;

  final String label;

  const TextFieldExample({required this.label, required this.field, super.key});

  @override
  Widget build(BuildContext context) {
    return FieldBuilder(
      field: field,
      builder: (context, field) {
        Widget? suffix;
        if (field.isValidating) {
          suffix = const SizedBox.square(
            dimension: 12,
            child: CircularProgressIndicator(),
          );
        }

        TextEditingController? controller;
        if (field is ControlledTextField) {
          controller = field<ControlledTextField>().textController;
        }

        return TextField(
          controller: controller,
          focusNode: field.focusNode,
          decoration: InputDecoration(labelText: label, errorText: field.errorText, suffix: suffix),
        );
      },
    );
  }
}
