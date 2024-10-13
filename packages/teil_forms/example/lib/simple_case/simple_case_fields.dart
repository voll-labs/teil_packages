import 'dart:async';

import 'package:teil_forms/teil_forms.dart';

sealed class SimpleField<T> extends TeilFormField<T> {
  SimpleField(super.value);
}

final class NameField extends SimpleField<String?> {
  NameField(super.value);

  @override
  FutureOr<String?> validate() {
    if (value != null || value!.isEmpty) return 'Name is required';
    return null;
  }
}

final class EmailField extends SimpleField<String?> {
  EmailField(super.value);
}

final class SimpleFormController extends TeilFormController<SimpleField<dynamic>> {
  final NameField name;

  final EmailField email;

  SimpleFormController({required this.name, required this.email});
}
