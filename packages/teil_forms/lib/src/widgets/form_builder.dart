import 'package:flutter/material.dart';
import 'package:teil_forms/src/form/form.dart';

typedef FormWidgetBuilder<C> = Widget Function(BuildContext context, C controller);

class FormBuilder<C extends BaseFormController> extends StatefulWidget {
  final C controller;

  final FormWidgetBuilder<C> builder;

  const FormBuilder({required this.builder, required this.controller, super.key});

  static C? maybeOf<C extends BaseFormController>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_FormScope>();
    assert(scope != null, 'No FormBuilder widget found in context.');
    return scope!.controller is C ? scope.controller as C : null;
  }

  static C of<C extends BaseFormController>(BuildContext context) {
    final controller = FormBuilder.maybeOf<C>(context);
    assert(controller != null, 'Invalid form controller type.');
    return controller!;
  }

  @override
  State<FormBuilder<C>> createState() => _FormBuilderState<C>();
}

class _FormBuilderState<C extends BaseFormController> extends State<FormBuilder<C>> {
  late C _controller;

  @override
  void initState() {
    _controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _FormScope(
      controller: _controller,
      child: Builder(builder: (context) => widget.builder(context, _controller)),
    );
  }
}

class _FormScope extends InheritedWidget {
  final BaseFormController controller;

  const _FormScope({required this.controller, required super.child});

  @override
  bool updateShouldNotify(_FormScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
