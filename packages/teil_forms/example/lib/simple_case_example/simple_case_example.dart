import 'package:example/src/entities/entities.dart';
import 'package:example/src/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

void main(List<String> args) {
  runApp(const MaterialApp(home: _SimpleCaseExample()));
}

class _SimpleCaseExample extends StatefulWidget {
  const _SimpleCaseExample();

  @override
  State<_SimpleCaseExample> createState() => _SimpleCaseExampleState();
}

class _SimpleCaseExampleState extends State<_SimpleCaseExample> {
  late SimpleFormController _controller;
  @override
  void initState() {
    _controller = SimpleFormController(
      name: NameField(''),
      email: EmailField(null),
      company: CompanyField(null),
      companyPosition: CompanyPositionField(null),
      radioExample: RadioExampleField(),
      activeProfile: ActiveProfileField(),
      agreeTerms: AgreeTermsField(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      controller: _controller,
      builder: (context, controller) => SimpleCasePage(controller: controller),
    );
  }
}
