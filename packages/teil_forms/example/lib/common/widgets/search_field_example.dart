import 'dart:async';

import 'package:example/common/common.dart';
import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

typedef SuggestionFetcher<T extends KeyValue> = FutureOr<Iterable<T>> Function(
  SearchController controller,
  TeilFormField<T?> field,
);

class SearchFieldExample<T extends KeyValue> extends StatefulWidget {
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
  State<SearchFieldExample<T>> createState() => _SearchFieldExampleState<T>();
}

class _SearchFieldExampleState<T extends KeyValue> extends State<SearchFieldExample<T>> {
  TextEditingController? _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.field.value?.value);
    widget.field.addListener(_valueListener);
  }

  void _valueListener() {
    _textController!.text = widget.field.value?.value ?? '';
  }

  @override
  void dispose() {
    widget.field.removeListener(_valueListener);
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FieldBuilder(
      field: widget.field,
      builder: (context, field) {
        return IgnorePointer(
          ignoring: !widget.enabled,
          child: SearchAnchor(
            key: Key(field.key),
            viewHintText: field.value?.value,
            suggestionsBuilder: (context, controller) async {
              final suggestions = await widget.suggestionsFetcher(controller, field);

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
              if (widget.clearable && field.value != null) {
                suffix = IconButton(onPressed: field.clear, icon: const Icon(Icons.clear_sharp));
              }

              return TextField(
                readOnly: true,
                enabled: widget.enabled,
                focusNode: field.focusNode,
                onTap: widget.enabled ? () => controller.openView() : null,
                controller: _textController,
                decoration: InputDecoration(
                  suffix: suffix,
                  labelText: widget.label,
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
