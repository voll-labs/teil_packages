import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teil_forms/teil_forms.dart';

void main() {
  group('Form focusable', () {
    testWidgets('When request focus, should focus on field', (tester) async {
      final controller = _FormController(
        name: _Field(''),
        email: _Field(null),
      );

      await tester.pumpWidget(_FormApp(controller: controller));
      await tester.pumpAndSettle();

      final nameTextField = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(Key(controller.name.key)),
          matching: find.byType(TextField),
        ),
      );
      expect(nameTextField.focusNode!.hasFocus, false);

      controller.name.requestFocus();
      await tester.pumpAndSettle();

      expect(nameTextField.focusNode!.hasFocus, true);

      controller.email.requestFocus();
      await tester.pumpAndSettle();

      expect(nameTextField.focusNode!.hasFocus, false);

      final emailField = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(Key(controller.email.key)),
          matching: find.byType(TextField),
        ),
      );

      expect(emailField.focusNode!.hasFocus, true);
    });
  });
}

class _FormController<F extends _Field> extends FormController<F> {
  final _Field<String> name;

  final _Field<String?> email;

  _FormController({required this.name, required this.email});
}

@optionalTypeArgs
class _Field<T> extends BaseFormField<T> with FormFieldFocusable<T> {
  _Field(super.value);
}

class _FormApp extends StatelessWidget {
  final _FormController controller;

  const _FormApp({required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FormBuilder(
          controller: controller,
          builder: (context, controller) {
            return Column(
              children: [
                FieldBuilder(
                  field: controller.name,
                  builder: (context, field) {
                    return TextFormField(
                      key: Key(field.key),
                      focusNode: field.focusNode,
                      initialValue: field.value,
                      onChanged: (v) => field.value = v,
                      decoration: const InputDecoration(labelText: 'Name'),
                    );
                  },
                ),
                FieldBuilder(
                  field: controller.email,
                  builder: (context, field) {
                    return TextFormField(
                      key: Key(field.key),
                      focusNode: field.focusNode,
                      initialValue: field.value,
                      onChanged: (v) => field.value = v,
                      decoration: const InputDecoration(labelText: 'Email'),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
