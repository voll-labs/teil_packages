import 'dart:async';

import 'package:example/simple_case/simple_case_mocks.dart';
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

typedef SuggestionFetcher = FutureOr<Iterable<KeyValue>> Function(
  SearchController controller,
  TeilFormField<KeyValue?> field,
);

class SearchFieldExample extends StatelessWidget {
  final String label;

  final bool enabled;

  final SuggestionFetcher suggestionsFetcher;

  const SearchFieldExample({
    required this.label,
    required this.suggestionsFetcher,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final field = FieldBuilder.of<TeilFormField<KeyValue?>>(context);

    return IgnorePointer(
      ignoring: !enabled,
      child: SearchAnchor(
        viewHintText: field.value?.value,
        suggestionsBuilder: (context, controller) async {
          final suggestions = await suggestionsFetcher(controller, field);

          return suggestions.map(
            (suggestion) => ListTile(
              title: Text(suggestion.value),
              onTap: () {
                field.value = suggestion;
                controller.closeView(null);
              },
            ),
          );
        },
        builder: (context, controller) {
          return TextField(
            readOnly: true,
            enabled: enabled,
            focusNode: field.focusNode,
            onTap: enabled ? () => controller.openView() : null,
            controller: TextEditingController(text: field.value?.value),
            decoration: InputDecoration(labelText: label, errorText: field.errorText),
          );
        },
      ),
    );
  }
}
