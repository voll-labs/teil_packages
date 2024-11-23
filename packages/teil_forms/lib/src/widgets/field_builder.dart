import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:teil_forms/src/form/form.dart';
import 'package:teil_forms/src/widgets/widgets.dart';

/// {@template field_builder_widget}
/// Widget for building a `field`.
///
/// It registers the `field` on the nearest [FormBuilder] ancestor.
///
/// {@endtemplate}
class FieldBuilder<F extends BaseFormField> extends StatefulWidget {
  /// The field instance to build.
  final F field;

  /// {@macro field_consumer_builder}
  ///
  /// Should be used to build the [Widget] of the `field`.
  final FieldWidgetBuilder<F> builder;

  /// {@macro field_builder_widget}
  const FieldBuilder({required this.field, required this.builder, super.key});

  /// Get the [BaseFormField] of the nearest [FieldBuilder] ancestor.
  static F of<F extends BaseFormField>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_FieldScope<F>>();
    assert(scope?.notifier != null, 'No Field(${F.runtimeType}) found in context.');
    return scope!.notifier!;
  }

  @override
  State<FieldBuilder<F>> createState() => _FieldBuilderState<F>();
}

class _FieldBuilderState<F extends BaseFormField> extends State<FieldBuilder<F>>
    with AutomaticKeepAliveClientMixin {
  F get _formField => widget.field;

  bool _registered = false;
  late FormController _formController;

  @override
  bool get wantKeepAlive => _registered;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return _FieldScope<F>(
      notifier: _formField,
      child: FieldConsumer(field: _formField, builder: widget.builder),
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
