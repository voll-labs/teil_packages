import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teil_forms/src/form/form.dart';

/// A key for a [FormBuilder].
typedef FormBuilderKey<C extends FormController> = GlobalKey<FormBuilderState<C>>;

/// A builder for a form widget.
typedef FormWidgetBuilder<C> = Widget Function(BuildContext context, C controller);

/// A constructor for a [FormController].
typedef FormControllerBuilder<C extends FormController> = FutureOr<C> Function();

/// A form builder.
class FormBuilder<C extends FormController> extends StatefulWidget {
  /// Create a [FormController].
  final FormControllerBuilder<C> controller;

  /// Form builder.
  final FormWidgetBuilder<C> builder;

  /// Loading indicator for asynchronous [FormController].
  final WidgetBuilder? loadingBuilder;

  /// Create a [FormBuilder] with synchronous [FormController].
  factory FormBuilder({required C controller, required FormWidgetBuilder<C> builder, Key? key}) {
    return FormBuilder.async(controller: () => controller, builder: builder, key: key);
  }

  /// Create a [FormBuilder] with asynchronous [FormController].
  const FormBuilder.async({
    required this.controller,
    required this.builder,
    this.loadingBuilder,
    super.key,
  });

  /// Try get the [FormController] of the nearest [FormBuilder] ancestor.
  static C? maybeOf<C extends FormController>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_FormScope>();
    assert(scope?.notifier != null, 'No FormContext(${C.runtimeType}) found in context.');
    return scope!.notifier is C ? scope.notifier! as C : null;
  }

  /// Get the [FormController] of the nearest [FormBuilder] ancestor.
  static C of<C extends FormController>(BuildContext context) {
    final controller = FormBuilder.maybeOf<C>(context);
    return controller!;
  }

  @override
  State<FormBuilder<C>> createState() => FormBuilderState<C>();
}

/// A state of [FormBuilder].
class FormBuilderState<C extends FormController> extends State<FormBuilder<C>> {
  late Completer<C> _controllerFuture;
  C? _controller;

  /// Get the [FormController].
  C get controller => _controller!;

  /// Get the [FormController] is ready.
  bool get isReady => _controller != null;

  @override
  void initState() {
    _controllerFuture = Completer<C>()
      ..complete(widget.controller())
      ..future.then((value) => _controller = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _controllerFuture.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingBuilder?.call(context) ?? const SizedBox();
        }

        return _FormScope(
          notifier: _controller,
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) => widget.builder(context, controller),
          ),
        );
      },
    );
  }
}

class _FormScope extends InheritedNotifier<FormController> {
  const _FormScope({required super.notifier, required super.child});
}
