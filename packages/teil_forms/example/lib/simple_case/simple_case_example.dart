import 'package:example/simple_case/simple_case_fields.dart';
import 'package:example/simple_case/simple_case_mocks.dart';
import 'package:example/widgets/search_field_example.dart';
import 'package:example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

void main(List<String> args) {
  runApp(const MaterialApp(home: SimpleCaseExample()));
}

class SimpleCaseExample extends StatefulWidget {
  const SimpleCaseExample({super.key});

  @override
  State<SimpleCaseExample> createState() => _SimpleCaseExampleState();
}

class _SimpleCaseExampleState extends State<SimpleCaseExample> {
  late SimpleFormController _controller;

  @override
  void initState() {
    _controller = SimpleFormController(
      name: NameField(''),
      email: EmailField(null),
      company: CompanyField(null),
      companyPosition: CompanyPositionField(null),
      agreeTerms: AgreeTermsField(value: false),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      controller: _controller,
      builder: (context, controller) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                FieldBuilder(
                  field: controller.name,
                  builder: (context, field) {
                    return TextFormField(
                      focusNode: field.focusNode,
                      controller: field.textController,
                      decoration: InputDecoration(labelText: 'Name', errorText: field.errorText),
                    );
                  },
                ),
                const SizedBox(height: 24),
                FieldBuilder(
                  field: controller.email,
                  builder: (context, field) {
                    return TextFormField(
                      focusNode: field.focusNode,
                      controller: field.textController,
                      decoration: InputDecoration(labelText: 'Email', errorText: field.errorText),
                    );
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
                FieldBuilder<TeilFormField<bool>>(
                  field: controller.agreeTerms,
                  builder: (context, field) {
                    return const CheckboxExample(label: 'Agree to terms');
                  },
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListenableBuilder(
                          // ignore: invalid_use_of_protected_member
                          listenable: Listenable.merge(controller.fields.values),
                          builder: (context, _) {
                            return Text(
                              // ignore: invalid_use_of_protected_member
                              'Values: [${controller.fields.values.map((f) => f.value).join(', ')}]',
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Text('Errors: ${controller.errors}'),
                        const SizedBox(height: 24),
                        Text('Dirty: ${controller.dirtyFields}'),
                        const SizedBox(height: 24),
                        Text('isSubmitting: ${controller.isSubmitting}'),
                        const SizedBox(height: 24),
                        Text('isValidating: ${controller.isValidating}'),
                      ],
                    ),
                  ),
                ),
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
