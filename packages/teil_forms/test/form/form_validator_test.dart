import 'package:flutter/material.dart' hide FormFieldValidator;
import 'package:flutter_test/flutter_test.dart';
import 'package:teil_forms/teil_forms.dart';

void main() {
  group('Form validator', () {
    testWidgets('When validate form, should validate all fields', (tester) async {
      final controller = _FormController(
        name: _ValidatedField(null),
        email: _Field(null),
      );

      await tester.pumpWidget(_FormApp(controller: controller));
      await tester.pumpAndSettle();

      expect(controller.isValidating, false);
      expect(controller.name.isValidating, false);
      expect(controller.email.isValidating, false);

      expect(controller.isValid, true);
      expect(controller.errors, isEmpty);

      expect(controller.name.errorText, isNull);
      expect(controller.email.errorText, isNull);

      await tester.tap(find.text('Validate'));
      await tester.pump();

      expect(controller.isValidating, true);
      expect(controller.name.isValidating, true);
      expect(controller.email.isValidating, false);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsNothing);

      expect(controller.isValidating, false);
      expect(controller.name.isValidating, false);

      expect(controller.isValid, false);
      expect(controller.errors, hasLength(1));

      expect(controller.name.errorText, 'Value is required');
      expect(controller.email.errorText, isNull);
    });
  });
}

class _FormController<F extends _Field> extends FormController<F> with FormValidator<F> {
  final _ValidatedField<String> name;

  final _Field<String?> email;

  _FormController({required this.name, required this.email});

  @override
  FieldValidationMode get validationMode => _validationMode ?? super.validationMode;
  late FieldValidationMode? _validationMode;
}

@optionalTypeArgs
class _Field<T> extends BaseFormField<T> with FormFieldValidator<T> {
  _Field(super.value);
}

class _ValidatedField<T> extends _Field<T?> {
  _ValidatedField(super.value);

  @override
  Future<String?> handleValidate() {
    return Future.delayed(const Duration(seconds: 1), () {
      if (value == null) return 'Value is required';
      return null;
    });
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
                      initialValue: field.value,
                      onChanged: (v) => field.value = v,
                      decoration: InputDecoration(labelText: 'Email', errorText: field.errorText),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => controller.validate(context),
                  child: controller.isValidating
                      ? const CircularProgressIndicator()
                      : const Text('Validate'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
