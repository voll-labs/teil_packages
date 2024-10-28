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
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                FieldBuilder(
                  field: controller.name,
                  builder: (context, field) {
                    return TextFormField(
                      focusNode: field.focusNode,
                      controller: field.textController,
                      decoration: InputDecoration(labelText: 'Name', errorText: field.errorText),
                    );
                  },
                ),
                const SizedBox(height: 24),
                FieldBuilder(
                  field: controller.email,
                  builder: (context, field) {
                    return TextFormField(
                      focusNode: field.focusNode,
                      controller: field.textController,
                      decoration: InputDecoration(labelText: 'Email', errorText: field.errorText),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ListenableBuilder(
                  listenable: Listenable.merge([controller.name, controller.email]),
                  builder: (context, _) {
                    return Text(
                      key: const Key('field_values'),
                      // ignore: invalid_use_of_protected_member
                      'Value: [${controller.fields.values.map((f) => f.value).join(', ')}]',
                    );
                  },
                ),
                Text(
                  key: const Key('field_dirty'),
                  // ignore: invalid_use_of_protected_member
                  'Dirty: ${controller.dirtyFields}',
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: controller.reset,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 24),
                FilledButton(
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
