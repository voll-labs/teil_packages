part of 'form.dart';

mixin FormFieldFocusable<T> on BaseFormField<T> {
  final FocusNode _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;

  @override
  @mustCallSuper
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
