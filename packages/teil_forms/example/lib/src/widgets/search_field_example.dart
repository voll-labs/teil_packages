import 'dart:async';

import 'package:example/src/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

typedef SuggestionFetcher<T extends KeyValue> = FutureOr<Iterable<T>> Function(
  SearchController controller,
  TeilFormField<T?> field,
);

class SearchFieldExample<T extends KeyValue> extends StatelessWidget {
  final TeilFormField<T?> field;

  final String label;

  final bool enabled;

  final bool clearable;

  final SuggestionFetcher<T> suggestionsFetcher;

  const SearchFieldExample({
    required this.field,
    required this.label,
    required this.suggestionsFetcher,
    this.enabled = true,
    this.clearable = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FieldBuilder(
      field: field,
      builder: (context, field) {
        return IgnorePointer(
          ignoring: !enabled,
          child: SearchAnchor(
            key: Key(field.key),
            viewHintText: field.value?.value,
            suggestionsBuilder: (context, controller) async {
              final suggestions = await suggestionsFetcher(controller, field);

              return suggestions.map(
                (suggestion) => ListTile(
                  key: Key('suggestion:$suggestion'),
                  title: Text(suggestion.value),
                  onTap: () {
                    field.value = suggestion;
                    controller.closeView(null);
                  },
                ),
              );
            },
            builder: (context, controller) {
              Widget? suffix;
              if (clearable && field.value != null) {
                suffix = IconButton(onPressed: field.clear, icon: const Icon(Icons.clear_sharp));
              }

              return TextField(
                readOnly: true,
                enabled: enabled,
                focusNode: field.focusNode,
                onTap: enabled ? () => controller.openView() : null,
                controller: TextEditingController(text: field.value?.value),
                decoration: InputDecoration(
                  suffix: suffix,
                  labelText: label,
                  errorText: field.errorText,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
