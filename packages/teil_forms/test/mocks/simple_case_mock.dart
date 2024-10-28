import 'dart:async';

import 'package:teil_forms/teil_forms.dart';

sealed class TestFieldState<T> extends TeilFormState<T> {
  TestFieldState(super.value);
}

final class NameField extends TestFieldState<String?> with ControlledTextField {
  NameField(super.value);

  @override
  FutureOr<String?> handleValidate() {
    final value = this.value;
    if (value == null || value.isEmpty) return 'Name is required';
    return null;
  }
}

final class EmailField extends TestFieldState<String?> with ControlledTextField {
  EmailField(super.value);
}
