import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teil_forms/teil_forms.dart';

void main() {
  group('Form submission', () {
    testWidgets('When submit form, should call [controller.handleSubmit]', (tester) async {
      final controller = _FormController(name: _Field(''));

      final spy = _SpyCallback();
      controller._onSubmit = spy;

      await tester.pumpWidget(_FormApp(controller: controller));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(Key(controller.name.key)), 'Test Person');
      expect(controller.name.value, 'Test Person');

      expect(controller.isSubmitting, false);
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(controller.isSubmitting, true);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      verify(spy.call).called(1);
    });

    test('Should build FormSubmission debugFillProperties', () async {
      final builder = DiagnosticPropertiesBuilder();
      _FormController(name: _Field('')).debugFillProperties(builder);

      final description = builder.properties.map((node) => node.name);
      expect(description, containsAll(['isSubmitting']));
    });
  });
}

class _SpyCallback extends Mock {
  void call();
}

class _FormController<F extends _Field> extends FormController<F> with FormSubmission<F> {
  final _Field<String> name;

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
class _Field<T> extends BaseFormField<T> {
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
