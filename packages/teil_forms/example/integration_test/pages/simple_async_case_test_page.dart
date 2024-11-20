import 'package:example/src/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teil_forms/teil_forms.dart';

import '../mocks/mocks.dart';
import 'pages.dart';

class SimpleAsyncCaseTestPage extends SimpleCaseTestPage {
  SimpleAsyncCaseTestPage(super.tester);

  @override
  Future<void> pumpPage(SimpleTestFormController controller) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FormBuilder.async(
          controller: () => Future.delayed(const Duration(seconds: 3), () => controller),
          loadingBuilder: (context) => const Scaffold(body: CircularProgressIndicator()),
          builder: (context, controller) => SimpleCasePage(controller: controller),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.byType(SimpleCasePage), findsOneWidget);
  }
}
