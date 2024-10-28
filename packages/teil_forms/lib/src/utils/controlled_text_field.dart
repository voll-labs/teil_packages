import 'package:flutter/widgets.dart';
import 'package:teil_forms/src/form/form.dart';

/// A mixin that provides a [TextEditingController] for a [BaseFormField] of type [String].
mixin ControlledTextField on BaseFormField<String?> {
  TextEditingController? _controller;

  void _valueListener() {
    if (_controller!.text != value) {
      _controller!.text = value ?? '';
    }
  }

  void _controllerListener() {
    value = _controller!.text;
  }

  /// Returns a [TextEditingController] that is connected to the [value] of the field.
  TextEditingController get textController {
    if (_controller != null) return _controller!;
    addListener(_valueListener);
    _controller = TextEditingController(text: value);
    _controller!.addListener(_controllerListener);
    return _controller!;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }
}
