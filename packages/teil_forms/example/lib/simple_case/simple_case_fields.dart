import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

sealed class SimpleFieldState<T> extends TeilFormState<T> {
  SimpleFieldState(super.value);
}

final class NameField extends SimpleFieldState<String?> with ControlledTextField {
  NameField(super.value);

  @override
  Future<String?> handleValidate() {
    return Future.delayed(const Duration(seconds: 3), () {
      if (value != null || value!.isEmpty) return 'Name is required';
      return null;
    });
  }
}

final class EmailField extends SimpleFieldState<String?> with ControlledTextField {
  EmailField(super.value);
}

final class SimpleFormController extends TeilFormController<SimpleFieldState> {
  final NameField name;

  final EmailField email;

  SimpleFormController({required this.name, required this.email});

  @override
  Future<void> handleSubmit(BuildContext context) async {
    print('Submit: [${fields.values}]');
  }
}
