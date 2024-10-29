import 'package:example/src/entities/entities.dart';
import 'package:example/src/pages/pages.dart';
import 'package:faker/faker.dart' show faker;
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

void main(List<String> args) {
  runApp(const MaterialApp(home: _SimpleAsyncCaseExample()));
}

class _SimpleAsyncCaseExample extends StatefulWidget {
  const _SimpleAsyncCaseExample();

  @override
  State<_SimpleAsyncCaseExample> createState() => _SimpleAsyncCaseExampleState();
}

class _SimpleAsyncCaseExampleState extends State<_SimpleAsyncCaseExample> {
  final _controllerKey = FormBuilderKey<SimpleAsyncFormController>();

  Future<SimpleAsyncFormController> _fetchController() async {
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
  Widget build(BuildContext context) {
    return FormBuilder.async(
      key: _controllerKey,
      controller: _fetchController,
      loadingBuilder: (context) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      builder: (context, controller) => SimpleCasePage(controller: controller),
    );
  }
}
