import 'package:example/src/entities/entities.dart';
import 'package:example/src/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teil_forms/teil_forms.dart';

import 'pages/pages.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Simple case', () {
    testWidgets('Should submit form values', (tester) async {
      final controller = SimpleTestFormController(
        name: NameField(null),
        email: EmailField(null),
        company: CompanyField(null),
        companyPosition: CompanyPositionField(null),
        radioExample: RadioExampleField(),
        activeProfile: ActiveProfileField(),
        agreeTerms: AgreeTermsField(),
      );

      final page = SimpleCaseTestPage(tester);
      await page.pumpPage(controller);

      await page.tapSubmitButton();

      verifyNever(() => controller.onSubmitted.call(any()));

      await page.enterTextField(controller.name, 'Test Person');

      expect(controller.name.value, 'Test Person');
      expect(controller.name.value, controller.name.textController.text);

      await tester.pumpAndSettle(const Duration(seconds: 3));
      await page.assertValues(['Test Person']);

      await page.enterTextField(controller.email, 'test@test.com');
      expect(controller.email.value, 'test@test.com');
      await page.assertValues(['test@test.com']);

      controller.email.value = 'manual_changed@test.com';
      await tester.pump();

      expect(controller.email.value, 'manual_changed@test.com');
      expect(controller.email.value, controller.email.textController.text);
      await page.assertValues(['manual_changed@test.com']);

      await page.assertSelectEnabled(controller.companyPosition, enabled: false);

      await page.selectSearchField(controller.company);

      await page.assertSelectEnabled(controller.companyPosition);

      await page.selectSearchField(controller.companyPosition);

      await page.selectRadioField(controller.radioExample, RadioExampleValue.two);

      await page.tapField(controller.activeProfile);

      await page.tapField(controller.agreeTerms);

      await page.tapSubmitButton();

      await tester.pumpAndSettle(const Duration(seconds: 3));

      verify(() => controller.onSubmitted.call(any())).called(1);
    });
  });
}

extension on SimpleCaseTestPage {
  Future<void> assertSelectEnabled(TeilFormField field, {bool enabled = true}) async {
    final findCompanyPosition = await findFormField(field);
    expect(
      tester.widget(findCompanyPosition),
      isA<SearchFieldExample>().having((e) => e.enabled, 'enabled', enabled),
    );
  }
}
