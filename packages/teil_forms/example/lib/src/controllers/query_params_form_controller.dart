import 'dart:async';
import 'dart:developer' as dev;

import 'package:example/example.dart';
import 'package:example/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QueryParamsFormController extends SimpleFormController {
  QueryParamsFormController({
    required super.name,
    required super.email,
    required super.company,
    required super.companyPosition,
    required super.radioExample,
    required super.activeProfile,
    required super.agreeTerms,
  });

  static Future<QueryParamsFormController> initialize(BuildContext context) async {
    final state = GoRouterState.of(context);
    final queryParams = state.uri.queryParameters;
    final values = QueryParamsExampleModel.fromBase64(queryParams['filter']);

    return Future.delayed(const Duration(seconds: 3), () {
      return QueryParamsFormController(
        name: NameField(values.name),
        email: EmailField(values.email),
        company: CompanyField(values.company),
        companyPosition: CompanyPositionField(values.companyPosition),
        radioExample: RadioExampleField(values.radioExample),
        activeProfile: ActiveProfileField(value: values.activeProfile),
        agreeTerms: AgreeTermsField(value: values.agreeTerms),
      );
    });
  }

  void _dispatchQueryParams(BuildContext context) {
    final queryParams = QueryParamsExampleModel(
      name: name.value,
      email: email.value,
      company: KeyValueModel.fromEntity(company.value),
      companyPosition: KeyValueModel.fromEntity(companyPosition.value),
      radioExample: radioExample.value,
      activeProfile: activeProfile.value,
      agreeTerms: agreeTerms.value,
    );

    final route = GoRouterState.of(context).uri;
    final newRoute = route.replace(queryParameters: {'filter': queryParams.toBase64()});
    dev.log('New Uri: $newRoute');

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Url updated')));
    unawaited(GoRouter.of(context).replace(newRoute.toString()));
  }

  @override
  @protected
  Future<void> handleSubmit(BuildContext context) async {
    dev.log('Submit: [${fields.values}]');

    if (!isDirty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form did not change')),
      );
      return;
    }

    _dispatchQueryParams(context);
  }
}
