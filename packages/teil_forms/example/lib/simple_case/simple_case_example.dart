import 'package:example/simple_case/simple_case_fields.dart';
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

void main(List<String> args) {
  runApp(const MaterialApp(home: SimpleCaseExample()));
}

class SimpleCaseExample extends StatefulWidget {
  const SimpleCaseExample({super.key});

  @override
  State<SimpleCaseExample> createState() => _SimpleCaseExampleState();
}

class _SimpleCaseExampleState extends State<SimpleCaseExample> {
  late SimpleFormController _controller;

  @override
  void initState() {
    _controller = SimpleFormController(
      name: NameField(''),
      email: EmailField(null),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      controller: _controller,
      builder: (context, controller) {
        return Scaffold(
          body: ListView(
            children: [
              FieldBuilder(
                field: controller.name,
                builder: (context, field) {
                  return TextFormField(
                    key: ValueKey(field),
                    initialValue: field.value,
                    onChanged: (value) => field.value = value,
                    decoration: InputDecoration(labelText: 'Name', errorText: field.errorText),
                  );
                },
              ),
              FieldBuilder(
                field: controller.email,
                builder: (context, field) {
                  return TextFormField(
                    key: ValueKey(field),
                    initialValue: field.value,
                    onChanged: (value) => field.value = value,
                    decoration: InputDecoration(labelText: 'Email', errorText: field.errorText),
                  );
                },
              ),
              ListenableBuilder(
                listenable: Listenable.merge([controller.name, controller.email]),
                builder: (context, _) {
                  return Text(
                    key: const Key('field_values'),
                    // ignore: invalid_use_of_protected_member
                    '[${controller.fields.values.map((f) => f.value).join(', ')}]',
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                // TODO(Ohashi): Add a button to reset the form
                // ElevatedButton(
                //   onPressed: controller.reset,
                //   child: const Text('Reset'),
                // ),
                ElevatedButton(
                  onPressed: !controller.isSubmitting ? () => controller.submit(context) : null,
                  child: controller.isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
