import 'dart:async';

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

  final AgreeTermsField agreeTerms;

  SimpleFormController({
    required this.name,
    required this.email,
    required this.company,
    required this.companyPosition,
    required this.agreeTerms,
  });

  @override
  Future<void> handleSubmit(BuildContext context) async {
    print('Submit: [${fields.values}]');
  }
}
