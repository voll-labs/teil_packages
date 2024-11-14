import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide FormFieldValidator;
import 'package:flutter_test/flutter_test.dart';
import 'package:teil_forms/teil_forms.dart';

void main() {
  group('Form validator', () {
    group('When default controller instantiated', () {
      late _FormController controller;

      setUp(() {
        controller = _FormController(name: _ValidatedField(null), email: _Field(null));
      });

      testWidgets('Should start with valid state', (tester) async {
        await tester.pumpWidget(_FormApp(controller: controller));
        await tester.pumpAndSettle();

        expect(
          controller.validationMode,
          FieldValidationMode.onSubmit,
          reason: 'Default validation mode should be onSubmit',
        );

        expect(controller.isValidating, false);
        expect(controller.name.isValidating, false);
        expect(controller.email.isValidating, false);

        expect(controller.isValid, true);
        expect(controller.errors, isEmpty);

        expect(controller.name.errorText, isNull);
        expect(controller.email.errorText, isNull);
      });

      testWidgets('Should validate all fields', (tester) async {
        await tester.pumpWidget(_FormApp(controller: controller));
        await tester.pumpAndSettle();

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

      testWidgets('Should validate field individually', (tester) async {
        await tester.pumpWidget(_FormApp(controller: controller));
        await tester.pumpAndSettle();

        final fieldValidation = expectLater(controller.name.validate(), completion(isFalse));

        expect(controller.isValidating, true);
        expect(controller.name.isValidating, true);
        expect(controller.email.isValidating, false);

        await tester.pump(const Duration(seconds: 1));
        await fieldValidation;

        expect(controller.isValidating, false);
        expect(controller.name.isValidating, false);

        expect(controller.isValid, false);
        expect(controller.errors, hasLength(1));

        expect(controller.name.errorText, 'Value is required');
      });

      testWidgets('Should set form errors manually', (tester) async {
        await tester.pumpWidget(_FormApp(controller: controller));
        await tester.pumpAndSettle();

        controller.setErrors({
          controller.name.key: 'Name is required',
          controller.email.key: 'Email is required',
        });

        await tester.pump();

        expect(controller.isValid, false);
        expect(controller.errors, hasLength(2));

        expect(controller.name.errorText, 'Name is required');
        expect(controller.email.errorText, 'Email is required');

        expect(find.text('Name is required'), findsOneWidget);
        expect(find.text('Email is required'), findsOneWidget);
      });

      testWidgets('Should set field error individually', (tester) async {
        await tester.pumpWidget(_FormApp(controller: controller));
        await tester.pumpAndSettle();

        controller.name.setError('Name is required');

        await tester.pump();

        expect(controller.isValid, false);
        expect(controller.errors, hasLength(1));

        expect(controller.name.errorText, 'Name is required');
        expect(controller.email.errorText, isNull);

        expect(find.text('Name is required'), findsOneWidget);
      });
    });

    group('When validation mode [onChanged]', () {
      late _FormController controller;

      setUp(() {
        controller = _FormController(
          name: _ValidatedField(null),
          email: _Field(null),
        ).._validationMode = FieldValidationMode.onChanged;
      });

      testWidgets('Should start with valid state', (tester) async {
        await tester.pumpWidget(_FormApp(controller: controller));
        await tester.pumpAndSettle();

        expect(controller.isValidating, false);
        expect(controller.name.isValidating, false);
        expect(controller.email.isValidating, false);

        expect(controller.isValid, true);
        expect(controller.errors, isEmpty);

        expect(controller.name.errorText, isNull);
        expect(controller.email.errorText, isNull);
      });

      testWidgets('Should validate on field change', (tester) async {
        await tester.pumpWidget(_FormApp(controller: controller));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(Key(controller.name.key)), 'A');
        await tester.pump();

        expect(controller.isValidating, true);
        expect(controller.name.isValidating, true);
        expect(controller.email.isValidating, false);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(CircularProgressIndicator), findsNothing);

        expect(controller.isValidating, false);
        expect(controller.name.isValidating, false);
        expect(controller.email.isValidating, false);

        expect(controller.isValid, false);
        expect(controller.errors, hasLength(1));

        expect(controller.name.errorText, 'Value is too short');
      });
    });

    test('Should build FormValidator debugFillProperties', () async {
      final builder = DiagnosticPropertiesBuilder();
      _FormController(
        name: _ValidatedField(null),
        email: _Field(null),
      ).debugFillProperties(builder);

      final description = builder.properties.map((node) => node.name);
      expect(description, containsAll(['isValidating', 'validationMode', 'errors', 'isValid']));
    });

    test('Should build FormFieldValidator debugFillProperties', () async {
      final builder = DiagnosticPropertiesBuilder();
      _Field(null).debugFillProperties(builder);

      final description = builder.properties.map((node) => node.name);
      expect(description, containsAll(['isValidating', 'errorText']));
    });
  });
}

class _FormController<F extends _Field> extends FormController<F> with FormValidator<F> {
  final _ValidatedField<String> name;

  final _Field<String?> email;

  _FormController({required this.name, required this.email});

  @override
  FieldValidationMode get validationMode => _validationMode ?? super.validationMode;
  FieldValidationMode? _validationMode;
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
      final value = this.value;
      if (value == null) return 'Value is required';
      if (value is String && value.length < 3) return 'Value is too short';

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
