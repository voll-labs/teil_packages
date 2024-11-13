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
              FieldBuilder<TeilFormField<String?>>(
                field: controller.name,
                builder: (context, field) {
                  return TextFieldExample(key: Key(field.key), label: 'Name');
                },
              ),
              const SizedBox(height: 24),
              FieldBuilder<TeilFormField<String?>>(
                field: controller.email,
                builder: (context, field) {
                  return TextFieldExample(key: Key(field.key), label: 'Email');
                },
              ),
              const SizedBox(height: 24),
              FieldBuilder<TeilFormField<KeyValue?>>(
                field: controller.company,
                builder: (context, field) {
                  return SearchFieldExample(
                    key: Key(field.key),
                    label: 'Company',
                    suggestionsFetcher: (controller, field) => fetchCompanies(),
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
                        key: Key(field.key),
                        label: 'Company position',
                        enabled: company != null,
                        suggestionsFetcher: (controller, field) => fetchCompanyPostions(),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              FieldBuilder<TeilFormField<RadioExampleValue>>(
                field: controller.radioExample,
                builder: (context, field) {
                  return RadioFieldExample(key: Key(field.key), values: RadioExampleValue.values);
                },
              ),
              const SizedBox(height: 24),
              FieldBuilder<TeilFormField<bool>>(
                field: controller.activeProfile,
                builder: (context, field) {
                  return SwitchFieldExample(key: Key(field.key), label: 'Active profile');
                },
              ),
              const SizedBox(height: 24),
              FieldBuilder<TeilFormField<bool>>(
                field: controller.agreeTerms,
                builder: (context, field) {
                  return CheckboxFieldExample(key: Key(field.key), label: 'Agree to terms');
                },
              ),
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
