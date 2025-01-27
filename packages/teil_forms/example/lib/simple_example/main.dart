import 'package:example/common/common.dart';
import 'package:example/simple_example/controllers/controllers.dart';
import 'package:example/simple_example/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teil_forms/teil_forms.dart';

void main(List<String> args) {
  runApp(MaterialApp.router(routerConfig: _router));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const _SimpleCaseExample(),
    ),
    GoRoute(
      path: '/async',
      builder: (context, state) => const _SimpleAsyncCaseExample(),
    ),
  ],
);

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
      builder: (context, controller) => _FormPage(controller: controller),
    );
  }
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
      builder: (context, controller) => _FormPage(controller: controller),
    );
  }
}

class _FormPage extends StatelessWidget {
  final SimpleFormController controller;

  const _FormPage({required this.controller});

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
                suggestionsFetcher: (controller, field) => FakerService.instance.fetchCompanies(),
              ),
              const SizedBox(height: 24),
              FieldConsumer(
                field: controller.company,
                builder: (context, company) {
                  return SearchFieldExample(
                    field: controller.companyPosition,
                    label: 'Company position',
                    enabled: company.value != null,
                    suggestionsFetcher: (controller, field) =>
                        FakerService.instance.fetchCompanies(),
                  );
                },
              ),
              const SizedBox(height: 24),
              RadioFieldExample(
                field: controller.radioExample,
                values: RadioExampleValue.values,
              ),
              const SizedBox(height: 24),
              SwitchFieldExample(
                field: controller.activeProfile,
                label: 'Active profile',
              ),
              const SizedBox(height: 24),
              CheckboxFieldExample(
                field: controller.agreeTerms,
                label: 'Agree to terms',
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
              onPressed: !controller.isSubmitting ? controller.submit : null,
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
