import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teil_forms/teil_forms.dart';

void main() {
  group('Form dirty', () {
    testWidgets('When fields change, should be dirty', (tester) async {
      final controller = _FormController(
        name: _Field(''),
        email: _Field(null),
      );

      await tester.pumpWidget(_FormApp(controller: controller));
      await tester.pumpAndSettle();

      expect(controller.isDirty, false);
      expect(controller.name.isDirty, false);
      expect(controller.email.isDirty, false);

      final findNameField = find.byKey(Key(controller.name.key));
      await tester.enterText(findNameField, 'Test Person');

      expect(controller.isDirty, true);
      expect(controller.name.isDirty, true);
      expect(controller.email.isDirty, false);

      final findEmailField = find.byKey(Key(controller.email.key));
      await tester.enterText(findEmailField, 'test@test.com');

      expect(controller.dirtyFields, {controller.name.key, controller.email.key});

      addTearDown(controller.dispose);
    });

    testWidgets('When fields returns to initial value, should not be dirty', (tester) async {
      final controller = _FormController(
        name: _Field('Initial value'),
        email: _Field(null),
      );

      await tester.pumpWidget(_FormApp(controller: controller));
      await tester.pumpAndSettle();

      expect(controller.isDirty, false);
      expect(controller.name.isDirty, false);

      final findNameField = find.byKey(Key(controller.name.key));
      await tester.enterText(findNameField, 'Test Person');

      expect(controller.isDirty, true);
      expect(controller.name.isDirty, true);

      await tester.enterText(findNameField, 'Initial value');

      expect(controller.isDirty, false);
      expect(controller.name.isDirty, false);

      addTearDown(controller.dispose);
    });

    test('Should build FormDirty debugFillProperties', () async {
      final builder = DiagnosticPropertiesBuilder();
      _FormController(name: _Field(''), email: _Field(null)).debugFillProperties(builder);

      final description = builder.properties.map((node) => node.name);
      expect(description, containsAll(['isDirty', 'dirtyFields']));
    });

    test('Should build FormFieldDirty debugFillProperties', () async {
      final builder = DiagnosticPropertiesBuilder();
      _Field(null).debugFillProperties(builder);

      final description = builder.properties.map((node) => node.name);
      expect(description, containsAll(['isDirty']));
    });
  });
}

class _FormController<F extends _Field> extends FormController<F> with FormDirty<F> {
  final _Field<String> name;

  final _Field<String?> email;

  _FormController({required this.name, required this.email});
}

@optionalTypeArgs
class _Field<T> extends BaseFormField<T> with FormFieldDirty<T> {
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
