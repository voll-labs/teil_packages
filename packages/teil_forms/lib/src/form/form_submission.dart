part of 'form.dart';

/// Mixin that provides submission for a [FormValidator].
mixin FormSubmission<F extends BaseFormField> on FormController<F> {
  bool _isSubmitting = false;

  /// Whether the [FormController] is submitting.
  bool get isSubmitting => _isSubmitting;

  /// Handle the form submission.
  @protected
  Future<void> handleSubmit(BuildContext context);

  Future<bool> _validate(BuildContext context) async {
    final form = tryCast<FormValidator>();
    await form?.validate(context);
    return form?.isValid ?? true;
  }

  /// Submit the [FormController] and return `true` if the form is valid.
  Future<void> submit(BuildContext context) async {
    if (isSubmitting) return;
    _isSubmitting = true;
    notifyListeners();

    final isValid = await _validate(context);
    if (!context.mounted) return;

    return startTransition(() async {
      if (isValid) await handleSubmit(context);

      _isSubmitting = false;
      notifyListeners();
    });
  }

  @override
  @mustCallSuper
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('isSubmitting', isSubmitting));
  }
}
