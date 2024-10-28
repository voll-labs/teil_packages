import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

class TextFieldExample extends StatelessWidget {
  final String label;

  const TextFieldExample({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    final field = FieldBuilder.of<TeilFormField<String?>>(context);

    Widget? suffix;
    if (field.isValidating) {
      suffix = const SizedBox.square(
        dimension: 12,
        child: CircularProgressIndicator(),
      );
    }

    return TextFormField(
      controller: (field as ControlledTextField).textController,
      focusNode: field.focusNode,
      decoration: InputDecoration(labelText: label, errorText: field.errorText, suffix: suffix),
    );
  }
}
