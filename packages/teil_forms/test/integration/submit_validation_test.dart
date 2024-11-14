import 'package:flutter/material.dart' hide FormFieldValidator;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teil_forms/teil_forms.dart';

void main() {
  testWidgets('Should not handle submit with invalid form', (tester) async {
    final controller = _FormController(name: _Field(null));

    final spy = _SpyCallback();
    controller._onSubmit = spy;

    await tester.pumpWidget(_FormApp(controller: controller));
    await tester.pumpAndSettle();

    expect(controller.isValidating, false);
    expect(controller.isSubmitting, false);

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(controller.isValidating, true);
    expect(controller.isSubmitting, true);

    await tester.pump(const Duration(seconds: 1));

    expect(controller.isValidating, false);
    expect(controller.isSubmitting, false);
    expect(controller.isValid, false);

    verifyNever(spy.call);
  });

  testWidgets('Should handle submit only with valid form', (tester) async {
    final controller = _FormController(name: _Field(null));

    final spy = _SpyCallback();
    controller._onSubmit = spy;

    await tester.pumpWidget(_FormApp(controller: controller));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key(controller.name.key)), 'Test Person');

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 2));

    expect(controller.isValid, true);

    verify(spy.call).called(1);
  });
}

class _SpyCallback extends Mock {
  void call();
}

class _FormController<F extends _Field> extends FormController<F>
    with FormSubmission<F>, FormValidator<F> {
  final _Field<String?> name;

  _FormController({required this.name});

  late _SpyCallback _onSubmit;

  @override
  @protected
  Future<void> handleSubmit(BuildContext context) {
    return Future.delayed(const Duration(seconds: 1), () {
      _onSubmit.call();
    });
  }
}

@optionalTypeArgs
class _Field<T> extends BaseFormField<T> with FormFieldValidator<T> {
  _Field(super.value);

  @override
  Future<String?> handleValidate() {
    return Future.delayed(const Duration(seconds: 1), () {
      final value = this.value;
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
                      decoration: const InputDecoration(labelText: 'Name'),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => controller.submit(context),
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
