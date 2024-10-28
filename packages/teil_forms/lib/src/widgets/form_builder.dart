import 'package:flutter/material.dart';
import 'package:teil_forms/src/form/form.dart';

/// A builder for a form widget.
typedef FormWidgetBuilder<C> = Widget Function(BuildContext context, C controller);

/// A form builder.
class FormBuilder<C extends FormContext> extends StatefulWidget {
  /// Form controller.
  final C controller;

  /// Form builder.
  final FormWidgetBuilder<C> builder;

  /// Create a form builder.
  const FormBuilder({required this.builder, required this.controller, super.key});

  /// Try get the [FormContext] of the nearest [FormBuilder] ancestor.
  static C? maybeOf<C extends FormContext>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_FormScope>();
    assert(scope?.notifier != null, 'No FormContext(${C.runtimeType}) found in context.');
    return scope!.notifier is C ? scope.notifier! as C : null;
  }

  /// Get the [FormContext] of the nearest [FormBuilder] ancestor.
  static C of<C extends FormContext>(BuildContext context) {
    final controller = FormBuilder.maybeOf<C>(context);
    return controller!;
  }

  @override
  State<FormBuilder<C>> createState() => _FormBuilderState<C>();
}

class _FormBuilderState<C extends FormContext> extends State<FormBuilder<C>> {
  late C _controller;

  @override
  void initState() {
    _controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _FormScope(
      notifier: _controller,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => widget.builder(context, _controller),
      ),
    );
  }
}

class _FormScope extends InheritedNotifier<FormContext> {
  const _FormScope({required super.notifier, required super.child});
}
