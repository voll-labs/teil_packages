part of 'form.dart';

typedef FormErrors = Map<FieldKey, String>;

mixin FormControllerValidator<F extends BaseFormField<dynamic>> on BaseFormController<F> {
  FormErrors _errors = {};
  FormErrors get errors => UnmodifiableMapView(_errors);

  Future<FormErrors> validate() async {
    final fieldsToValidate = fields.values.whereType<FormFieldValidator<dynamic>>();

    final errors = await Future.wait(
      fieldsToValidate.map((field) async {
        field.setValidating();
        final error = await field.validate();
        if (error != null) return MapEntry(field.key, error);
      }),
    );

    return Map.fromEntries(errors.nonNulls);
  }

  void setErrors(FormErrors errors) {
    if (errors != _errors) {
      _errors = errors;
      _errors.forEach(_dispatchErrors);
      notifyListeners();
    }
  }

  void _dispatchErrors(FieldKey key, String error) {
    final field = fields[key];
    if (field is FormFieldValidator) {
      field.setError(error);
    }
  }

  Future<bool> _validate() async {
    final validations = await validate();
    setErrors(validations);
    return _errors.isEmpty;
  }
}

mixin FormFieldValidator<T> on BaseFormField<T> {
  String? _errorText;
  String? get errorText => _errorText;
  bool get hasError => _errorText != null;

  bool _isValidating = false;
  bool get isValidating => _isValidating;

  void setValidating() {
    if (!_isValidating) {
      _isValidating = true;
      notifyListeners();
    }
  }

  void setError(String? error) {
    _isValidating = false;

    if (_errorText != error) {
      _errorText = error;
      notifyListeners();
    }
  }

  FutureOr<String?> validate() => null;
}
