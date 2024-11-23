import 'package:example/src/controllers/controllers.dart';
import 'package:example/src/entities/entities.dart';
import 'package:example/src/mocks/mocks.dart';
import 'package:example/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

class SimpleCasePage extends StatelessWidget {
  final SimpleFormController controller;

  const SimpleCasePage({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextFieldExample(field: controller.name, label: 'Email'),
              const SizedBox(height: 24),
              TextFieldExample(field: controller.email, label: 'Email'),
              const SizedBox(height: 24),
              SearchFieldExample(
                field: controller.company,
                label: 'Company',
                suggestionsFetcher: (controller, field) => fetchCompanies(),
              ),
              const SizedBox(height: 24),
              FieldConsumer(
                field: controller.company,
                builder: (context, company) {
                  return SearchFieldExample(
                    field: controller.companyPosition,
                    label: 'Company position',
                    enabled: company.value != null,
                    suggestionsFetcher: (controller, field) => fetchCompanyPostions(),
                  );
                },
              ),
              const SizedBox(height: 24),
              RadioFieldExample(field: controller.radioExample, values: RadioExampleValue.values),
              const SizedBox(height: 24),
              SwitchFieldExample(field: controller.activeProfile, label: 'Active profile'),
              const SizedBox(height: 24),
              CheckboxFieldExample(field: controller.agreeTerms, label: 'Agree to terms'),
              const SizedBox(height: 24),
              const CardFormDetail(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            const Spacer(),
            TextButton(
              key: const Key('clear_button'),
              onPressed: controller.clear,
              child: const Text('Clear'),
            ),
            const SizedBox(width: 24),
            TextButton(
              key: const Key('reset_button'),
              onPressed: controller.reset,
              child: const Text('Reset'),
            ),
            const SizedBox(width: 24),
            FilledButton(
              key: const Key('submit_button'),
              onPressed: !controller.isSubmitting ? () => controller.submit(context) : null,
              child: controller.isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
