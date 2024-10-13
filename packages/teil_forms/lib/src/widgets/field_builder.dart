import 'package:flutter/material.dart';
import 'package:teil_forms/src/form/form.dart';
import 'package:teil_forms/src/widgets/widgets.dart';

typedef FieldWidgetBuilder<F> = Widget Function(BuildContext context, F field);

class FieldBuilder<F extends BaseFormField<dynamic>> extends StatefulWidget {
  final F field;

  final FieldWidgetBuilder<F> builder;

  const FieldBuilder({required this.field, required this.builder, super.key});

  @override
  State<FieldBuilder<F>> createState() => _FieldBuilderState<F>();
}

class _FieldBuilderState<F extends BaseFormField<dynamic>> extends State<FieldBuilder<F>> {
  late F _field;

  bool _registered = false;
  late BaseFormController _formController;

  @override
  void initState() {
    _field = widget.field;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _formController = FormBuilder.of(context);
    if (!_registered) {
      _formController.register(_field);
      _registered = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_registered) _formController.unregister(_field);
    _field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _field,
      builder: (context, _, __) => widget.builder(context, _field),
    );
  }
}
