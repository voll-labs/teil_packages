import 'package:example/simple_case/simple_case_fields.dart';
import 'package:example/simple_case/simple_case_mocks.dart';
import 'package:example/widgets/widgets.dart';
import 'package:faker/faker.dart' show faker;
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

void main(List<String> args) {
  runApp(const MaterialApp(home: SimpleAsyncCaseExample()));
}

class SimpleAsyncCaseExample extends StatefulWidget {
  const SimpleAsyncCaseExample({super.key});

  @override
  State<SimpleAsyncCaseExample> createState() => _SimpleAsyncCaseExampleState();
}

class _SimpleAsyncCaseExampleState extends State<SimpleAsyncCaseExample> {
  final _controllerKey = FormBuilderKey<SimpleFormController>();

  Future<SimpleFormController> _fetchController() async {
    return Future.delayed(const Duration(seconds: 3), () {
      return SimpleFormController(
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
      builder: (context, controller) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                FieldBuilder<TeilFormField<String?>>(
                  field: controller.name,
                  builder: (context, field) {
                    return const TextFieldExample(label: 'Name');
                  },
                ),
                const SizedBox(height: 24),
                FieldBuilder<TeilFormField<String?>>(
                  field: controller.email,
                  builder: (context, field) {
                    return const TextFieldExample(label: 'Email');
                  },
                ),
                const SizedBox(height: 24),
                FieldBuilder<TeilFormField<KeyValue?>>(
                  field: controller.company,
                  builder: (context, field) {
                    return SearchFieldExample(
                      label: 'Company',
                      suggestionsFetcher: (controller, field) => Company.fetchList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
                FieldBuilder<TeilFormField<KeyValue?>>(
                  field: controller.companyPosition,
                  builder: (context, field) {
                    return ValueListenableBuilder(
                      valueListenable: controller.company,
                      builder: (context, company, __) {
                        return SearchFieldExample(
                          label: 'Company position',
                          enabled: company != null,
                          suggestionsFetcher: (controller, field) => CompanyPosition.fetchList(),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                FieldBuilder<TeilFormField<RadioExampleValue>>(
                  field: controller.radioExample,
                  builder: (context, field) {
                    return const RadioFieldExample(values: RadioExampleValue.values);
                  },
                ),
                const SizedBox(height: 24),
                FieldBuilder<TeilFormField<bool>>(
                  field: controller.activeProfile,
                  builder: (context, field) {
                    return const SwitchFieldExample(label: 'Active profile');
                  },
                ),
                const SizedBox(height: 24),
                FieldBuilder<TeilFormField<bool>>(
                  field: controller.agreeTerms,
                  builder: (context, field) {
                    return const CheckboxFieldExample(label: 'Agree to terms');
                  },
                ),
                const SizedBox(height: 24),
                const CardFormDetail(),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: controller.reset,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 24),
                FilledButton(
                  onPressed: !controller.isSubmitting ? () => controller.submit(context) : null,
                  child: controller.isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
