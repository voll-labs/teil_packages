import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teil_forms/teil_forms.dart';

void main() {
  group('Form resetter', () {
    late _FormController controller;

    setUp(() {
      controller = _FormController(
        name: _Field(''),
        email: _ControllerField('initial@test.com'),
      );
    });

    testWidgets('Should reset all fields values', (tester) async {
      await tester.pumpWidget(_FormApp(controller: controller));
      await tester.pumpAndSettle();

      final findNameField = find.byKey(Key(controller.name.key));
      await tester.enterText(findNameField, 'Test Person');
      expect(controller.name.value, 'Test Person');
      expect(controller.name.initialValue, '');

      final findEmailField = find.byKey(Key(controller.email.key));
      await tester.enterText(findEmailField, 'changed@test.com');
      expect(controller.email.value, 'changed@test.com');
      expect(controller.email.initialValue, 'initial@test.com');

      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      final nameTextField = tester.widget<TextField>(
        find.descendant(
          of: findNameField,
          matching: find.byType(TextField),
        ),
      );

      expect(controller.name.value, controller.name.initialValue);
      expect(
        nameTextField.controller!.text,
        'Test Person',
        reason: 'Should not reset the text field since it is not controlled.',
      );

      final emailTextField = tester.widget<TextField>(
        find.descendant(
          of: findEmailField,
          matching: find.byType(TextField),
        ),
      );
      expect(controller.email.value, controller.email.initialValue);
      expect(emailTextField.controller!.text, 'initial@test.com');
    });

    testWidgets('Should clear all fields values', (tester) async {
      await tester.pumpWidget(_FormApp(controller: controller));
      await tester.pumpAndSettle();

      final findNameField = find.byKey(Key(controller.name.key));
      await tester.enterText(findNameField, 'Test Person');

      final findEmailField = find.byKey(Key(controller.email.key));
      await tester.enterText(findEmailField, 'changed@test.com');

      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      expect(
        controller.name.value,
        controller.name.initialValue,
        reason: 'Should set the value to initial value since it is not nullable.',
      );

      expect(controller.email.value, isNull);
      expect(
        controller.email.initialValue,
        'initial@test.com',
        reason: "Shouldn't change the initial value.",
      );
    });

    testWidgets('Should reset field individually', (tester) async {
      await tester.pumpWidget(_FormApp(controller: controller));
      await tester.pumpAndSettle();

      controller.email.reset(_ControllerField('reseted@test.com'));
      expect(controller.email.value, 'reseted@test.com');

      final findEmailField = find.byKey(Key(controller.email.key));
      await tester.enterText(findEmailField, 'changed@test.com');

      controller.resetField(controller.email.key, field: _ControllerField('reseted@test.com'));
      expect(controller.email.value, 'reseted@test.com');
    });

    testWidgets('Should clear field individually', (tester) async {
      await tester.pumpWidget(_FormApp(controller: controller));
      await tester.pumpAndSettle();

      final findEmailField = find.byKey(Key(controller.email.key));

      await tester.enterText(findEmailField, 'changed@test.com');
      controller.email.clear();
      expect(controller.email.value, isNull);

      await tester.enterText(findEmailField, 'changed@test.com');
      controller.clearField(controller.email.key);
      expect(controller.email.value, isNull);
    });

    tearDown(() => controller.dispose());
  });
}

class _FormController<F extends _Field> extends FormController<F> with FormResetter<F> {
  final _Field<String> name;

  final _ControllerField email;

  _FormController({required this.name, required this.email});
}

@optionalTypeArgs
class _Field<T> extends BaseFormField<T> with FormFieldResetter<T> {
  _Field(super.value);
}

class _ControllerField extends _Field<String?> with ControlledTextField {
  _ControllerField(super.value);
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
                      controller: field.textController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => controller.clear(),
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: () => controller.reset(),
                  child: const Text('Reset'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
