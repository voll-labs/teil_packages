import 'package:flutter/material.dart' hide FormFieldValidator;
import 'package:flutter_test/flutter_test.dart';
import 'package:teil_forms/teil_forms.dart';

void main() {
  testWidgets('Should focus on first invalid field', (tester) async {
    final controller = _FormController(name: _TextField(null), email: _TextField(null));

    await tester.pumpWidget(_FormApp(controller: controller));
    await tester.pumpAndSettle();

    final findNameTextField = find.descendant(
      of: find.byKey(Key(controller.name.key)),
      matching: find.byType(TextField),
    );
    final nameTextField = tester.widget<TextField>(findNameTextField);
    expect(nameTextField.focusNode!.hasFocus, false);

    await tester.enterText(findNameTextField, 'Teste Person');

    final emailTextField = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(Key(controller.email.key)),
        matching: find.byType(TextField),
      ),
    );
    expect(emailTextField.focusNode!.hasFocus, false);

    await tester.tap(find.text('Validate'));
    await tester.pump();

    expect(nameTextField.focusNode!.hasFocus, false);
    expect(emailTextField.focusNode!.hasFocus, true);
  });
}

class _FormController<F extends _Field> extends FormController<F> with FormValidator<F> {
  final _TextField name;

  final _TextField email;

  _FormController({required this.name, required this.email});
}

@optionalTypeArgs
class _Field<T> extends BaseFormField<T> with FormFieldFocusable<T>, FormFieldValidator<T> {
  _Field(super.value);
}

class _TextField extends _Field<String?> {
  _TextField(super.value);

  @override
  String? didValidate() {
    final value = this.value;
    if (value == null) return 'Value is required';
    if (value.length < 3) return 'Value is too short';

    return null;
  }
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
                      decoration: InputDecoration(labelText: 'Name', errorText: field.errorText),
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
                      decoration: InputDecoration(labelText: 'Email', errorText: field.errorText),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => controller.validate(),
                  child: const Text('Validate'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
