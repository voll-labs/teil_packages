import 'package:example/query_params_example/main.dart' as query_params_example;
import 'package:example/simple_example/main.dart' as simple_example;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main(List<String> args) {
  runApp(MaterialApp.router(routerConfig: _router));
}

final _routes = [
  ...simple_example.routes,
  ...query_params_example.routes,
];

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const _HomePage(),
      routes: _routes,
    ),
  ],
);

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teil Forms Examples'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(_routes.length, (index) {
              final route = _routes[index];
              final routeName = route.path.startsWith('/') ? route.path.substring(1) : route.path;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () => context.go(route.path),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.description, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          routeName,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
