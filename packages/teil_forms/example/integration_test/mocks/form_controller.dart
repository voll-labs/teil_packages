import 'package:example/example.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teil_forms/teil_forms.dart';

final class _SpyCallback extends Mock {
  void call(FormFields<SimpleFormField> fields);
}

class SimpleTestFormController extends SimpleFormController {
  SimpleTestFormController({
    required super.name,
    required super.email,
    required super.company,
    required super.companyPosition,
    required super.radioExample,
    required super.activeProfile,
    required super.agreeTerms,
  });

  final onSubmitted = _SpyCallback();

  @override
  Future<void> didSubmit() async {
    onSubmitted.call(fields);
  }
}
