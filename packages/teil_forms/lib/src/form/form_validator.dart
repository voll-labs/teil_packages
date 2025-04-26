part of 'form.dart';

/// The errors of a form.
typedef FormErrors = Map<FieldKey, String>;

/// Mixin that provides [FormController] validation functionality.
///
/// - Should be used with [FormFieldValidator] to validate the fields.
/// - Can be used with [FormFieldFocusable] to focus on the field when it has an error.
mixin FormValidator<F extends FormFieldValidator> on FormController<F> {
  /// The validation mode of the [FormController].
  ///
  /// Defaults to [FieldValidationMode.onSubmit].
  FieldValidationMode get validationMode => FieldValidationMode.onSubmit;

  bool _isValidating = false;

  /// Whether the [FormController] is validating.
  bool get isValidating => _isValidating;

  final FormErrors _errors = {};

  /// Whether the [FormController] has no errors.
  bool get isValid => _errors.isEmpty;

  /// The errors of the [FormController].
  FormErrors get errors => UnmodifiableMapView(_errors);

  Future<F?> _validateField(FieldKey key) async {
    final field = fields[key];
    if (field == null) return null;

    await field._validate();
    setFieldError(key, field.errorText);

    if (!field.hasError) return null;
    return field;
  }

  /// Validate a field and return the field if it has an error.
  Future<F?> validateField(FieldKey key) async {
    _isValidating = true;
    notifyListeners();

    return startTransition(() async {
      final field = await _validateField(key);
      _isValidating = false;
      notifyListeners();
      return field;
    });
  }

  /// Validate the [FormController] and return `true` if the form is valid.
  Future<bool> validate() async {
    _isValidating = true;
    notifyListeners();

    return startTransition(() async {
      final fieldsWithError = await Future.wait(fields.keys.map(_validateField));
      final field = fieldsWithError.nonNulls.firstOrNull;
      field?.tryCast<FormFieldFocusable>()?.requestFocus();

      _isValidating = false;
      notifyListeners();

      return isValid;
    });
  }

  /// Set a unique field error.
  void setFieldError(FieldKey key, String? error) {
    final field = fields[key];
    if (field == null) return;

    field._setError(error);
    _errors.upsertError(key, error);
    notifyListeners();
  }

  /// Set the errors of [FormController].
  void setErrors(FormErrors errors) {
    if (_errors == errors) return;

    startTransition(() {
      for (final entry in errors.entries) {
        setFieldError(entry.key, entry.value);
      }
    });
  }

  @override
  @mustCallSuper
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('isValidating', isValidating))
      ..add(DiagnosticsProperty('validationMode', validationMode))
      ..add(DiagnosticsProperty('errors', errors))
      ..add(DiagnosticsProperty('isValid', isValid));
  }
}

/// Mixin that provides validation for a [BaseFormField].
///
/// - Should be used with [FormValidator] to validate the field.
/// - Can be used with [FormFieldFocusable] to focus on the field when it has an error.
@optionalTypeArgs
mixin FormFieldValidator<T> on BaseFormField<T> {
  bool _isValidating = false;

  /// Whether the field is validating.
  bool get isValidating => _isValidating;

  String? _errorText;

  /// The error message of the field.
  String? get errorText => _errorText;

  /// Whether the field has an error.
  bool get hasError => _errorText != null;

  /// Validate the field and return an error message if the field is invalid.
  @protected
  FutureOr<String?> didValidate() => null;

  FutureOr<void> _validate() async {
    _isValidating = true;
    notifyListeners();

    return startTransition(() async {
      final error = await didValidate();
      _setError(error);

      _isValidating = false;
      notifyListeners();
    });
  }

  /// Called by the [FormController] to validate the field.
  @protected
  @visibleForTesting
  FutureOr<bool> validate() async {
    final field = await context<FormValidator>().validateField(key);
    field?.tryCast<FormFieldFocusable>()?.requestFocus();

    return field == null;
  }

  void _setError(String? error) {
    if (_errorText == error) return;
    _errorText = error;
    notifyListeners();
  }

  /// Called by the [FormController] to set the error message.
  @protected
  @visibleForTesting
  void setError(String? error) => context<FormValidator>().setFieldError(key, error);

  @override
  set value(T value) {
    super.value = value;

    final form = context<FormValidator>();
    if (form.validationMode.shouldValidate(FieldValidationMode.onChanged)) {
      form.validateField(key);
    }
  }

  @override
  @mustCallSuper
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isValidating', isValidating))
      ..add(DiagnosticsProperty<String>('errorText', errorText));
  }
}

extension on FormErrors {
  void upsertError(FieldKey key, String? error) {
    if (error != null) {
      this[key] = error;
      return;
    }
    remove(key);
  }
}
