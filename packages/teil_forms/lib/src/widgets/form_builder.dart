import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:teil_forms/teil_forms.dart';

/// Signature for the [GlobalKey] of a [FormBuilder].
typedef FormBuilderKey<C extends FormController> = GlobalKey<FormBuilderState<C>>;

/// Signature for the [FormController] `widget.builder` function.
typedef FormWidgetBuilder<C> = Widget Function(BuildContext context, C controller);

/// Signature for the [FormController] `builder` function.
typedef FormControllerBuilder<C extends FormController> = FutureOr<C> Function();

/// {@template form_builder_widget}
/// Base [Widget] to bind [FormController] to the UI tree.
///
/// Should be used as the root of the form, and should be the parent of all [FieldBuilder]s.
///
/// **The [FormController] instance should be unique.**
/// {@endtemplate}
class FormBuilder<C extends FormController> extends StatefulWidget {
  /// Create the main instance of the [FormController].
  final FormControllerBuilder<C> controller;

  /// The [FormWidgetBuilder] which will be called on every `form` notification.
  /// Should be used as a `builder` for the `form`.
  final FormWidgetBuilder<C> builder;

  /// Loading indicator for async [FormController].
  final WidgetBuilder? loadingBuilder;

  /// {@macro form_builder_widget}
  ///
  /// Create a [FormBuilder] with synchronous [FormController].
  ///
  /// ```dart
  /// FormBuilder(
  ///  controller: MyFormController(),
  ///  builder: (context, controller) {
  ///   return Column(
  ///    children: [
  ///    ...fields
  ///   ],
  /// );
  /// ```
  factory FormBuilder({required C controller, required FormWidgetBuilder<C> builder, Key? key}) {
    return FormBuilder.async(controller: () => controller, builder: builder, key: key);
  }

  /// {@macro form_builder_widget}
  ///
  /// Create a [FormBuilder] with asynchronous [FormController].
  ///
  /// ```dart
  /// FormBuilder.async(
  ///  controller: () async => MyFormController(),
  ///  loadingBuilder: (context) => const CircularProgressIndicator(),
  ///  builder: (context, controller) {
  ///   return Column(
  ///    children: [
  ///    ...fields
  ///   ],
  /// );
  /// ```
  const FormBuilder.async({
    required this.controller,
    required this.builder,
    this.loadingBuilder,
    super.key,
  });

  /// Get the [FormController] of the nearest [FormBuilder] ancestor.
  static C of<C extends FormController>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_FormScope>();
    assert(scope?.notifier != null, 'No FormContext(${C.runtimeType}) found in context.');
    return scope!.notifier! as C;
  }

  @override
  State<FormBuilder<C>> createState() => FormBuilderState<C>();
}

/// A state of [FormBuilder].
class FormBuilderState<C extends FormController> extends State<FormBuilder<C>>
    with AutomaticKeepAliveClientMixin {
  late Completer<C> _controllerFuture;
  C? _controller;

  /// Get the [FormController].
  C get controller {
    assert(isReady, 'FormController is not ready.');
    return _controller!;
  }

  /// Get the [FormController] is ready.
  bool get isReady => _controller != null;

  @override
  bool get wantKeepAlive => isReady;

  @override
  void initState() {
    _controllerFuture = Completer<C>()
      ..complete(widget.controller())
      ..future.then((value) => _controller = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('controller', controller));
  }
}

class _FormScope extends InheritedNotifier<FormController> {
  const _FormScope({required super.notifier, required super.child});
}
