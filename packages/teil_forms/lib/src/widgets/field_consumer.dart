import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

/// Signature for the `field listener` function.
typedef FieldWidgetListener<F> = void Function(F field);

/// Signature for the `field builder` function.
typedef FieldWidgetBuilder<F> = Widget Function(BuildContext context, F field);

/// {@template field_consumer_widget}
/// A widget that listens to a `field` notification.
///
/// - Should **only** be used when a `field` is needed to be `listened` to.
/// - At least one of `builder` or `listener` must be provided.
/// - The `child` widget is required if `builder` is not provided.
///
/// ```dart
/// void build(BuildContext context) {
///   final field = FieldBuilder.of<MyCustomField>(context);
///
///   return FieldConsumer(
///     field: field,
///     listener: (field) {
///       print(field.value);
///     },
///     builder: (context, field) {
///       return Text(field.value);
///     },
///   );
/// }
/// ```
/// {@endtemplate}
class FieldConsumer<F extends BaseFormField> extends StatefulWidget {
  /// The `field` instance to listen to.
  final F field;

  /// The [Widget] which will be rendered if [builder] is not provided.
  final Widget? child;

  /// {@template field_consumer_builder}
  /// The [FieldWidgetBuilder] which will be called on every `field` notification.
  /// {@endtemplate}
  ///
  /// Should be used to build [Widget] which needs to be changed
  /// in response to a `field`.
  final FieldWidgetBuilder<F>? builder;

  /// The [FieldWidgetListener] which will be called on every `field` notification.
  ///
  /// Should be used for any code which needs to execute
  /// in response to a `field`.
  final FieldWidgetListener<F>? listener;

  /// {@macro field_consumer_widget}
  const FieldConsumer({required this.field, this.child, this.builder, this.listener, super.key})
      : assert(builder != null || listener != null, 'builder or listener must be provided.'),
        assert(child != null || builder != null, 'child or builder must be provided.');

  @override
  State<FieldConsumer<F>> createState() => _FieldConsumerState<F>();
}

class _FieldConsumerState<F extends BaseFormField> extends State<FieldConsumer<F>> {
  F get _formField => widget.field;

  @override
  void initState() {
    if (widget.listener != null) _formField.addListener(_fieldListener);
    super.initState();
  }

  void _fieldListener() {
    widget.listener!(_formField);

    if (!mounted || widget.builder == null) return;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant FieldConsumer<F> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.listener != null && _formField != oldWidget.field) {
      oldWidget.field.removeListener(_fieldListener);
      widget.field.addListener(_fieldListener);
    }
  }

  @override
  void dispose() {
    if (widget.listener != null) _formField.removeListener(_fieldListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(context, _formField);
    }

    return widget.child!;
  }
}
