import 'package:example/common/common.dart';
import 'package:example/src/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teil_forms/teil_forms.dart';

import '../mocks/mocks.dart';

class SimpleCaseTestPage {
  final WidgetTester tester;

  const SimpleCaseTestPage(this.tester);

  Future<void> pumpPage(SimpleTestFormController controller) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FormBuilder(
          controller: controller,
          builder: (context, controller) => SimpleCasePage(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SimpleCasePage), findsOneWidget);
  }

  Future<void> tapSubmitButton() async {
    final findSubmitButton = find.byKey(const Key('submit_button'));
    await tester.tap(findSubmitButton);
    await tester.pump();
  }

  Future<void> tapResetButton() async {
    final findResetButton = find.byKey(const Key('reset_button'));
    await tester.tap(findResetButton);
    await tester.pump();
  }

  Future<Finder> findFormField(TeilFormField field) async {
    final findField = find.byKey(Key(field.key));
    await tester.ensureVisible(findField);
    return findField;
  }

  Future<void> tapField(TeilFormField field) async {
    final findField = await findFormField(field);
    await tester.tap(findField);
    await tester.pump();
  }

  Future<void> enterTextField(TeilFormField field, String text) async {
    final findField = await findFormField(field);
    await tester.enterText(findField, text);
    await tester.pump();
  }

  Future<void> selectSearchField(
    TeilFormField field, {
    Duration duration = const Duration(seconds: 1),
  }) async {
    await tapField(field);
    await tester.pumpAndSettle(duration);

    final findSuggestions = find.byWidgetPredicate((w) => w.key.toString().contains('suggestion:'));
    await tester.tap(findSuggestions.first);
    await tester.pump();
  }

  Future<void> selectRadioField<T>(TeilFormField field, T value) async {
    final findField = await findFormField(field);
    final findRadioField = find.descendant(of: findField, matching: find.byKey(ValueKey(value)));
    await tester.tap(findRadioField);
    await tester.pump();
  }

  Future<void> assertValues(List<String> values) async {
    final findFormValues = find.byKey(const Key('form_values'));
    await tester.ensureVisible(findFormValues);
    expect(findFormValues, findsOneWidget);

    final formData = tester.widget<Text>(findFormValues).data;
    for (final value in values) {
      expect(formData, contains(value), reason: 'Value not found in form data: $value');
    }
  }

  Future<void> assertSelectEnabled(TeilFormField field, {bool enabled = true}) async {
    final findCompanyPosition = await findFormField(field);
    expect(
      tester.widget(findCompanyPosition),
      isA<SearchFieldExample>().having((e) => e.enabled, 'enabled', enabled),
    );
  }
}
