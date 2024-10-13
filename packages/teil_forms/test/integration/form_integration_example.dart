import 'dart:async';

import 'package:teil_forms/teil_forms.dart';

sealed class TestField<T> extends TeilFormField<T> {
  TestField(super.value);
}

final class NameField extends TestField<String?> {
  NameField(super.value);

  @override
  FutureOr<String?> validate() {
    if (value != null || value!.isEmpty) return 'Name is required';
    return null;
  }
}

final class EmailField extends TestField<String?> {
  EmailField(super.value);
}
