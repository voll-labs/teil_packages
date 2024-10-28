import 'package:teil_forms/src/form/form.dart';

/// The mode of validation for a [FormController].
enum FieldValidationMode {
  /// The field is validated when the form is submitted.
  onSubmit,

  /// The field is validated when the field is changed or submitted.
  onChanged;

  /// Whether the field should be validated at the given [location].
  bool shouldValidate(FieldValidationMode location) {
    if (location == onSubmit && this == onSubmit) return true;
    if (location == onChanged && this == onChanged) return true;

    return false;
  }
}
