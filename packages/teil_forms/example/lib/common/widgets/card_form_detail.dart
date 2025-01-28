import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

class CardFormDetail extends StatelessWidget {
  const CardFormDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final form = FormBuilder.of<TeilFormController>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListenableBuilder(
              // Ignored for example purposes
              // ignore: invalid_use_of_protected_member
              listenable: Listenable.merge(form.fields.values),
              builder: (context, _) {
                return Text(
                  key: const Key('form_values'),
                  // Ignored for example purposes
                  // ignore: invalid_use_of_protected_member
                  'Values: [${form.fields.values.map((f) => f.value).join(', ')}]',
                );
              },
            ),
            const SizedBox(height: 24),
            Text(key: const Key('form_errors'), 'Errors: ${form.errors}'),
            const SizedBox(height: 24),
            Text('isValid: ${form.isValid}'),
            const SizedBox(height: 24),
            Text('Dirty: ${form.dirtyFields}'),
            const SizedBox(height: 24),
            Text('isSubmitting: ${form.isSubmitting}'),
            const SizedBox(height: 24),
            Text('isValidating: ${form.isValidating}'),
          ],
        ),
      ),
    );
  }
}
