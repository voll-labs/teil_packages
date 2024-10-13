part of 'form.dart';

mixin FormControllerSubmitter<F extends BaseFormField<dynamic>> on BaseFormController<F> {
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  void setSubmitting({bool submitting = true}) {
    if (_isSubmitting != submitting) {
      _isSubmitting = submitting;
      notifyListeners();
    }
  }

  Future<void> submit(BuildContext context) async {}

  Future<void> _submit(BuildContext context) async {
    setSubmitting();
    await submit(context);
    setSubmitting(submitting: false);
  }
}
