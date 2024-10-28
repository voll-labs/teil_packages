import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

class CheckboxExample extends StatelessWidget {
  final String label;

  const CheckboxExample({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorsScheme = Theme.of(context).colorScheme;

    final field = FieldBuilder.of<TeilFormField<bool>>(context);

    TextStyle? titleStyle;
    if (field.errorText != null) {
      titleStyle = textTheme.bodyLarge?.copyWith(color: colorsScheme.error);
    }

    Widget? subtitle;
    if (field.errorText != null) {
      subtitle = Text(
        field.errorText!,
        style: textTheme.bodyMedium?.copyWith(color: colorsScheme.error),
      );
    }

    return CheckboxListTile(
      value: field.value,
      focusNode: field.focusNode,
      onChanged: (value) => field.value = value ?? false,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: titleStyle),
      subtitle: subtitle,
      isError: field.errorText != null,
    );
  }
}