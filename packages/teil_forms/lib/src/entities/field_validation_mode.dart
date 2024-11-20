import 'package:teil_forms/src/form/form.dart';

/// The mode of validation for a [FormController].
enum FieldValidationMode {
  /// The field is validated when the form is submitted.
  onSubmit,

  /// The field is validated when the field is changed or submitted.
  onChanged;

  /// Whether the field should be validated at the given [location].
  bool shouldValidate(FieldValidationMode location) {
    switch (this) {
      case FieldValidationMode.onSubmit:
        return location == onSubmit;
      case FieldValidationMode.onChanged:
        return location == onChanged || location == onSubmit;
    }
  }
}
