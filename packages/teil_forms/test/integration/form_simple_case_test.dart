import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teil_forms/teil_forms.dart';

import '../mocks/mocks.dart';

void main() {
  group('FormSimpleCasePage', () {
    testWidgets('Should submit form values', (tester) async {
      final controller = TestFormController(
        name: NameField(''),
        email: EmailField(null),
      ).._onSubmitted = _SpyCallback();

      await tester.pumpWidget(MaterialApp(home: FormSimpleCasePage(controller: controller)));
      await tester.pumpAndSettle();

      expect(find.byType(FormSimpleCasePage), findsOneWidget);

      final findNameField = find.byKey(Key(controller.name.key));
      await tester.enterText(findNameField, 'Test Person');
      await tester.pump();

      expect(controller.name.value, 'Test Person');
      expect(controller.name.value, controller.name.textController.text);
      expect(find.text('[Test Person, null]'), findsOneWidget);

      final findEmailField = find.byKey(Key(controller.email.key));
      await tester.enterText(findEmailField, 'test@test.com');
      await tester.pump();

      expect(controller.email.value, 'test@test.com');
      expect(controller.email.value, controller.email.textController.text);
      expect(find.text('[Test Person, test@test.com]'), findsOneWidget);

      controller.email.value = 'changed@test.com';
      await tester.pump();

      expect(controller.email.value, 'changed@test.com');
      expect(controller.email.value, controller.email.textController.text);
      expect(find.text('[Test Person, changed@test.com]'), findsOneWidget);

      final findSubmitButton = find.byKey(const Key('submit_button'));
      await tester.tap(findSubmitButton);
      await tester.pump();

      verify(() => controller._onSubmitted.call()).called(1);
    });
  });
}

class _SpyCallback extends Mock {
  _SpyCallback();
  void call();
}

final class TestFormController extends TeilFormController<TestFieldState> {
  final NameField name;

  final EmailField email;

  late _SpyCallback _onSubmitted;

  TestFormController({required this.name, required this.email});

  @override
  Future<void> handleSubmit(BuildContext context) async {
    _onSubmitted();
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
                    controller: field.textController,
                    decoration: InputDecoration(labelText: 'Name', errorText: field.errorText),
                  );
                },
              ),
              FieldBuilder(
                field: controller.email,
                builder: (context, field) {
                  return TextFormField(
                    key: Key(field.key),
                    controller: field.textController,
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
                TextButton(
                  key: const Key('reset_button'),
                  onPressed: controller.reset,
                  child: const Text('Reset'),
                ),
                ElevatedButton(
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
      },
    );
  }
}
