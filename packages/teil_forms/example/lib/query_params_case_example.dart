import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teil_forms/teil_forms.dart';

void main(List<String> args) {
  runApp(MaterialApp.router(routerConfig: _router));
}

final _router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => const _QueryParamsCaseExample())],
);

class _QueryParamsCaseExample extends StatefulWidget {
  const _QueryParamsCaseExample();

  @override
  State<_QueryParamsCaseExample> createState() => _QueryParamsCaseExampleState();
}

class _QueryParamsCaseExampleState extends State<_QueryParamsCaseExample> {
  final _controllerKey = FormBuilderKey<QueryParamsFormController>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder.async(
      key: _controllerKey,
      controller: () => QueryParamsFormController.initialize(context),
      loadingBuilder: (context) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      builder: (context, controller) => SimpleCasePage(controller: controller),
    );
  }
}
