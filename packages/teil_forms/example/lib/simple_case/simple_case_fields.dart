import 'dart:async';
import 'dart:developer';

import 'package:example/simple_case/simple_case_mocks.dart';
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

sealed class SimpleFieldState<T> extends TeilFormField<T> {
  SimpleFieldState(super.value);
}

final class NameField extends SimpleFieldState<String?> with ControlledTextField {
  NameField(super.value);

  @override
  Future<String?> handleValidate() {
    return Future.delayed(const Duration(seconds: 3), () {
      final value = this.value;
      if (value == null || value.isEmpty) return 'Name is required';
      if (value.length < 3) return 'Name must be at least 3 characters';
      return null;
    });
  }
}

final class EmailField extends SimpleFieldState<String?> with ControlledTextField {
  EmailField(super.value);
}

final class CompanyField extends SimpleFieldState<Company?> {
  CompanyField(super.value);

  @override
  String? handleValidate() {
    if (value == null) return 'Company is required';
    return null;
  }
}

final class CompanyPositionField extends SimpleFieldState<CompanyPosition?> {
  CompanyPositionField(super.value);

  @override
  String? handleValidate() {
    if (value == null) return 'Company position is required';
    return null;
  }
}

final class RadioExampleField extends SimpleFieldState<RadioExampleValue> {
  RadioExampleField([super.value = RadioExampleValue.one]);

  @override
  String? handleValidate() {
    if (value == RadioExampleValue.one) return 'You must select an option greater than one';
    return null;
  }
}

final class ActiveProfileField extends SimpleFieldState<bool> {
  ActiveProfileField({bool? value}) : super(value ?? false);

  @override
  String? handleValidate() {
    if (!value) return 'You must activate your profile';
    return null;
  }
}

final class AgreeTermsField extends SimpleFieldState<bool> {
  AgreeTermsField({bool? value}) : super(value ?? false);

  @override
  String? handleValidate() {
    if (!value) return 'You must agree to the terms';
    return null;
  }
}

final class SimpleFormController extends TeilFormController<SimpleFieldState> {
  final NameField name;

  final EmailField email;

  final CompanyField company;

  final CompanyPositionField companyPosition;

  final RadioExampleField radioExample;

  final ActiveProfileField activeProfile;

  final AgreeTermsField agreeTerms;

  SimpleFormController({
    required this.name,
    required this.email,
    required this.company,
    required this.companyPosition,
    required this.radioExample,
    required this.activeProfile,
    required this.agreeTerms,
  });

  @override
  FieldValidationMode get validationMode => FieldValidationMode.onChanged;

  @override
  Future<void> handleSubmit(BuildContext context) async {
    log('Submit: [${fields.values}]');

    final scaffolMessenger = ScaffoldMessenger.of(context);
    if (!isDirty) {
      scaffolMessenger.showSnackBar(const SnackBar(content: Text('Form did not change')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Form submitted')));
  }
}
