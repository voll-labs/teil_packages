import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teil form example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Form(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Semantics(
                checked: true,
                child: const SizedBox(height: 16),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              FormField<bool>(
                builder: (field) {
                  return Checkbox(
                    value: field.value,
                    tristate: field.value == null,
                    onChanged: field.didChange,
                  );
                },
              ),
              const SizedBox(height: 16),
              Radio(value: true, groupValue: true, onChanged: (value) {}),
              const SizedBox(height: 16),
              FormField<bool>(
                builder: (field) {
                  return Switch(
                    value: field.value ?? false,
                    onChanged: field.didChange,
                  );
                },
              ),
              const SizedBox(height: 16),
              FormField<double>(
                initialValue: 0.5,
                builder: (field) {
                  return Slider(
                    value: field.value ?? 0,
                    onChanged: field.didChange,
                  );
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                validator: (value) {
                  if (value == null) {
                    return 'Please select an item';
                  }
                  return null;
                },
                onChanged: (value) {},
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Item 1')),
                  DropdownMenuItem(value: 2, child: Text('Item 2')),
                ],
              ),
              const SizedBox(height: 16),
              SearchAnchor(
                suggestionsBuilder: (context, controller) {
                  return [
                    ListTile(
                      title: const Text('Item 1'),
                      onTap: () {
                        controller.text = 'Item 1';
                      },
                    ),
                    ListTile(
                      title: const Text('Item 2'),
                      onTap: () {
                        controller.text = 'Item 2';
                      },
                    ),
                  ];
                },
                builder: (context, anchor) {
                  return TextField(
                    readOnly: true,
                    onTap: () {
                      anchor.openView();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      suffixIcon: Icon(Icons.search),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
