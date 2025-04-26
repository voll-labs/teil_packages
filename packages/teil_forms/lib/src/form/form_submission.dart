part of 'form.dart';

/// Mixin that provides [FormController] submission functionality.
///
/// Can be used with [FormValidator] to handle form validation.
mixin FormSubmission<F extends BaseFormField> on FormController<F> {
  bool _isSubmitting = false;

  /// Whether the [FormController] is submitting.
  bool get isSubmitting => _isSubmitting;

  /// Handle the form submission.
  @protected
  Future<void> didSubmit() async {
    assert(false, 'Form submission not implemented. Override didSubmit() in your FormController.');
  }

  Future<bool> _validate() async {
    final form = tryCast<FormValidator>();
    if (form == null) return true;
    return form.validate();
  }

  /// Submit the [FormController] and return `true` if the form is submitted successfully.
  Future<bool> submit() async {
    if (isSubmitting) return false;
    _isSubmitting = true;
    notifyListeners();

    try {
      final isValid = await _validate();
      if (isValid) await didSubmit();

      _isSubmitting = false;
      notifyListeners();

      return isValid;
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  @mustCallSuper
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('isSubmitting', isSubmitting));
  }
}
