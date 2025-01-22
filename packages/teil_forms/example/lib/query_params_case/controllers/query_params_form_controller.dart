import 'package:example/query_params_case/entities/entities.dart';
import 'package:example/query_params_case/models/models.dart';
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

  // void _dispatchQueryParams(BuildContext context) {
  //   final queryParams = QueryParamsExampleModel(
  //     name: name.value,
  //     email: email.value,
  //     company: KeyValueModel.fromEntity(company.value),
  //     companyPosition: KeyValueModel.fromEntity(companyPosition.value),
  //     radioExample: radioExample.value,
  //     activeProfile: activeProfile.value,
  //     agreeTerms: agreeTerms.value,
  //   );

  //   final route = GoRouterState.of(context).uri;
  //   final newRoute = route.replace(queryParameters: {'filter': queryParams.toBase64()});
  //   dev.log('New Uri: $newRoute');

  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Url updated')));
  //   unawaited(GoRouter.of(context).replace(newRoute.toString()));
  // }

  // @override
  // @protected
  // Future<void> onSubmit(BuildContext context) async {
  //   dev.log('Submit: [${fields.values}]');

  //   if (!isDirty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Form did not change')),
  //     );
  //     return;
  //   }

  //   _dispatchQueryParams(context);
  // }
}
