import 'dart:async';

import 'package:example/src/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

@optionalTypeArgs
sealed class SimpleFormField<T> extends TeilFormField<T> {
  SimpleFormField(super.value);
}

final class NameField extends SimpleFormField<String?> with ControlledTextField {
  NameField(super.value);

  @override
  Future<String?> onValidate() {
    return Future.delayed(const Duration(seconds: 3), () {
      final value = this.value;
      if (value == null || value.isEmpty) return 'Name is required';
      if (value.length < 3) return 'Name must be at least 3 characters';
      return null;
    });
  }
}

final class EmailField extends SimpleFormField<String?> with ControlledTextField {
  EmailField(super.value);
}

final class CompanyField extends SimpleFormField<KeyValue?> {
  CompanyField(super.value);

  @override
  String? onValidate() {
    if (value == null) return 'Company is required';
    return null;
  }
}

final class CompanyPositionField extends SimpleFormField<KeyValue?> {
  CompanyPositionField(super.value);

  @override
  String? onValidate() {
    if (value == null) return 'Company position is required';
    return null;
  }
}

final class RadioExampleField extends SimpleFormField<RadioExampleValue> {
  RadioExampleField([super.value = RadioExampleValue.one]);

  @override
  String? onValidate() {
    if (value == RadioExampleValue.one) return 'You must select an option greater than one';
    return null;
  }
}

final class ActiveProfileField extends SimpleFormField<bool> {
  ActiveProfileField({bool? value}) : super(value ?? false);

  @override
  String? onValidate() {
    if (!value) return 'You must activate your profile';
    return null;
  }
}

final class AgreeTermsField extends SimpleFormField<bool> {
  AgreeTermsField({bool? value}) : super(value ?? false);

  @override
  String? onValidate() {
    if (!value) return 'You must agree to the terms';
    return null;
  }
}
