part of 'form.dart';

/// Mixin that provides submission for a [FormValidator].
mixin FormSubmission<F extends FormFieldValidator> on FormValidator<F> {
  bool _isSubmitting = false;

  /// Whether the [FormContext] is submitting.
  bool get isSubmitting => _isSubmitting;

  /// Handle the form submission.
  @protected
  Future<void> handleSubmit(BuildContext context);

  /// Submit the [FormContext] and return `true` if the form is valid.
  Future<void> submit(BuildContext context) async {
    if (isSubmitting) return;
    _isSubmitting = true;
    notifyListeners();

    final isValid = await validate(context);
    if (!context.mounted) return;

    return startTransition(() {
      if (isValid) return handleSubmit(context);

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
