import 'package:example/src/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/mocks.dart';
import 'pages/pages.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Simple async case', () {
    testWidgets('Should handle async controller and submit', (tester) async {
      final controller = SimpleTestFormController(
        name: NameField('Test Person'),
        email: EmailField('test@test.com'),
        company: CompanyField(const KeyValue(id: '1', value: 'Test Company')),
        companyPosition: CompanyPositionField(null),
        radioExample: RadioExampleField(),
        activeProfile: ActiveProfileField(),
        agreeTerms: AgreeTermsField(),
      );

      final page = SimpleAsyncCaseTestPage(tester);
      await page.pumpPage(controller);

      expect(controller.name.value, 'Test Person');
      expect(controller.email.value, 'test@test.com');
      await page.assertValues(['Test Person', 'test@test.com', 'Test Company']);

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
