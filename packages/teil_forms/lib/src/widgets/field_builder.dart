import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:teil_forms/src/form/form.dart';
import 'package:teil_forms/src/widgets/widgets.dart';

/// A builder for a field widget.
typedef FieldWidgetBuilder<F> = Widget Function(BuildContext context, F field);

/// A field builder.
class FieldBuilder<F extends BaseFormField> extends StatefulWidget {
  /// The field to build.
  final F field;

  /// The field widget builder.
  final FieldWidgetBuilder<F> builder;

  /// Create a field builder.
  const FieldBuilder({required this.field, required this.builder, super.key});

  /// Try get the [BaseFormField] of the nearest [FieldBuilder] ancestor.
  static F? maybeOf<F extends BaseFormField>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_FieldScope<F>>();
    assert(scope?.notifier != null, 'No Field(${F.runtimeType}) found in context.');
    return scope!.notifier;
  }

  /// Get the [BaseFormField] of the nearest [FieldBuilder] ancestor.
  static F of<F extends BaseFormField>(BuildContext context) {
    final controller = FieldBuilder.maybeOf<F>(context);
    return controller!;
  }

  @override
  State<FieldBuilder<F>> createState() => _FieldBuilderState<F>();
}

class _FieldBuilderState<F extends BaseFormField> extends State<FieldBuilder<F>>
    with AutomaticKeepAliveClientMixin {
  late F _formField;

  bool _registered = false;
  late FormController _formController;

  @override
  bool get wantKeepAlive => _registered;

  @override
  void initState() {
    _formField = widget.field;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _formController = FormBuilder.of(context);
    if (!_registered) {
      _formController.register(_formField);
      _registered = true;
    }
  }

  @override
  void dispose() {
    if (_registered) _formController.unregister(_formField);
    _formField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return _FieldScope<F>(
      notifier: _formField,
      child: ValueListenableBuilder(
        valueListenable: _formField,
        builder: (context, _, __) => widget.builder(context, _formField),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('field', _formField))
      ..add(DiagnosticsProperty('field_registered', _registered));
  }
}

class _FieldScope<F extends BaseFormField> extends InheritedNotifier<F> {
  const _FieldScope({required super.notifier, required super.child});
}
