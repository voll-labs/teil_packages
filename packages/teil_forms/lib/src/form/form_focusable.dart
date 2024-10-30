part of 'form.dart';

/// Mixin that provides focus functionality to [FormField].
@optionalTypeArgs
mixin FormFieldFocusable<T> on BaseFormField<T> {
  final FocusNode _focusNode = FocusNode();

  /// The focus node of the field.
  FocusNode get focusNode => _focusNode;

  /// Request focus for the field.
  void requestFocus() {
    if (_focusNode.canRequestFocus) _focusNode.requestFocus();
  }

  @override
  @mustCallSuper
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  @mustCallSuper
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('hasFocus', _focusNode.hasFocus));
  }
}
