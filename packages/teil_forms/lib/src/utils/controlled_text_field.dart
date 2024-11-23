import 'package:flutter/material.dart';
import 'package:teil_forms/src/form/form.dart';

/// Provides [TextEditingController] for a [BaseFormField] of type [String].
///
/// - Can be used with [TextField] or relatives that use [TextEditingController] to control the text.
mixin ControlledTextField on BaseFormField<String?> {
  TextEditingController? _controller;

  void _valueListener() {
    if (_controller!.text != value) {
      _controller!.text = value ?? '';
    }
  }

  void _controllerListener() {
    final textValue = _controller!.text.isNotEmpty ? _controller!.text : null;
    if (value != textValue) {
      value = textValue;
    }
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
    removeListener(_valueListener);
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }
}
