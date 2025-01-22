import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

class FormBottomActions extends StatelessWidget {
  const FormBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FormBuilder.of<TeilFormController>(context);

    return Row(
      children: [
        const Spacer(),
        TextButton(
          key: const Key('clear_button'),
          onPressed: controller.clear,
          child: const Text('Clear'),
        ),
        const SizedBox(width: 24),
        TextButton(
          key: const Key('reset_button'),
          onPressed: controller.reset,
          child: const Text('Reset'),
        ),
        const SizedBox(width: 24),
        FilledButton(
          key: const Key('submit_button'),
          onPressed: !controller.isSubmitting ? controller.submit : null,
          child: controller.isSubmitting ? const CircularProgressIndicator() : const Text('Submit'),
        ),
      ],
    );
  }
}
