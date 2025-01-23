import 'dart:developer' as dev;

import 'package:example/simple_example/entities/entities.dart';
import 'package:faker/faker.dart' show faker;
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

class SimpleFormController extends TeilFormController<SimpleFormField> {
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
  @protected
  Future<void> didSubmit() async {
    dev.log('Submit: [${fields.values}]');
    if (!isDirty) throw Exception('Form is not dirty');
  }
}

class SimpleAsyncFormController extends SimpleFormController {
  SimpleAsyncFormController({
    required super.name,
    required super.email,
    required super.company,
    required super.companyPosition,
    required super.radioExample,
    required super.activeProfile,
    required super.agreeTerms,
  });

  static Future<SimpleAsyncFormController> initialize() async {
    return Future.delayed(const Duration(seconds: 3), () {
      return SimpleAsyncFormController(
        name: NameField(faker.person.name()),
        email: EmailField(faker.internet.email()),
        company: CompanyField(null),
        companyPosition: CompanyPositionField(null),
        radioExample: RadioExampleField(RadioExampleValue.two),
        activeProfile: ActiveProfileField(value: true),
        agreeTerms: AgreeTermsField(value: true),
      );
    });
  }

  @override
  FieldValidationMode get validationMode => FieldValidationMode.onChanged;
}
