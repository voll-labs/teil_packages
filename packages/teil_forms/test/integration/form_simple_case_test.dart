import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teil_forms/teil_forms.dart';

import '../mocks/mocks.dart';

void main() {
  group('FormSimpleCasePage', () {
    testWidgets('Should trigger form values changes', (tester) async {
      final controller = TestFormController(
        name: NameField(''),
        email: EmailField(null),
      );

      await tester.pumpWidget(MaterialApp(home: FormSimpleCasePage(controller: controller)));
      await tester.pumpAndSettle();

      expect(find.byType(FormSimpleCasePage), findsOneWidget);

      final findNameField = find.byKey(Key(controller.name.key));
      await tester.enterText(findNameField, 'Test Person');
      await tester.pump();

      expect(controller.name.value, 'Test Person');
      expect(find.text('[Test Person, null]'), findsOneWidget);

      final findEmailField = find.byKey(Key(controller.email.key));
      await tester.enterText(findEmailField, 'test@test.com');
      await tester.pump();

      expect(controller.email.value, 'test@test.com');
      expect(find.text('[Test Person, test@test.com]'), findsOneWidget);

      controller.email.value = 'changed@test.com';
      await tester.pump();

      expect(controller.email.value, 'changed@test.com');
      expect(find.text('[Test Person, changed@test.com]'), findsOneWidget);
    });
  });
}

final class TestFormController extends TeilFormController<TestFieldState> {
  final NameField name;

  final EmailField email;

  TestFormController({required this.name, required this.email});

  @override
  Future<void> handleSubmit(BuildContext context) {
    // TODO: implement handleSubmit
    throw UnimplementedError();
  }
}

class FormSimpleCasePage extends StatefulWidget {
  final TestFormController controller;

  const FormSimpleCasePage({required this.controller, super.key});

  @override
  State<FormSimpleCasePage> createState() => _FormSimpleCasePageState();
}

class _FormSimpleCasePageState extends State<FormSimpleCasePage> {
  TestFormController get _controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      controller: _controller,
      builder: (context, controller) {
        return Scaffold(
          body: ListView(
            children: [
              FieldBuilder(
                field: controller.name,
                builder: (context, field) {
                  return TextFormField(
                    key: Key(field.key),
                    initialValue: field.value,
                    onChanged: (value) => field.value = value,
                    decoration: InputDecoration(labelText: 'Name', errorText: field.errorText),
                  );
                },
              ),
              FieldBuilder(
                field: controller.email,
                builder: (context, field) {
                  return TextFormField(
                    key: Key(field.key),
                    initialValue: field.value,
                    onChanged: (value) => field.value = value,
                    decoration: InputDecoration(labelText: 'Email', errorText: field.errorText),
                  );
                },
              ),
              ListenableBuilder(
                listenable: Listenable.merge([controller.name, controller.email]),
                builder: (context, _) {
                  return Text(
                    key: const Key('field_values'),
                    // ignore: invalid_use_of_protected_member
                    '[${controller.fields.values.map((f) => f.value).join(', ')}]',
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                // TODO(Ohashi): Add a button to reset the form
                // ElevatedButton(
                //   onPressed: controller.reset,
                //   child: const Text('Reset'),
                // ),
                ElevatedButton(
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
