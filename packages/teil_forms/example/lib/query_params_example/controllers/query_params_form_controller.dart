import 'dart:developer' as dev;

import 'package:example/query_params_example/entities/entities.dart';
import 'package:example/query_params_example/models/models.dart';
import 'package:flutter/widgets.dart';
import 'package:teil_forms/teil_forms.dart';

class QueryParamsFormController extends TeilFormController<QueryParamsField> {
  final EmailField email;

  final CompanyField company;

  final AgreeTermsField agreeTerms;

  QueryParamsFormController({
    required this.email,
    required this.company,
    required this.agreeTerms,
  });

  static Future<QueryParamsFormController> fromUri(Uri uri) async {
    final queryParams = uri.queryParameters;
    final values = QueryParamsExampleModel.fromBase64(queryParams['filter']);

    return Future.delayed(const Duration(seconds: 3), () {
      return QueryParamsFormController(
        email: EmailField(values.email),
        company: CompanyField(values.company),
        agreeTerms: AgreeTermsField(value: values.agreeTerms),
      );
    });
  }

  @override
  @protected
  Future<void> didSubmit() async {
    dev.log('Submit: [${fields.values}]');
    if (!isDirty) throw Exception('Form did not change');
  }
}
