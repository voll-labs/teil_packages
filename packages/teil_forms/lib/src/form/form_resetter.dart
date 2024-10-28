part of 'form.dart';

/// Mixin that provides a method to reset a form field.
mixin FormResetter<F extends FormFieldResetter> on FormController<F> {
  /// Resets the field with the given [key].
  void resetField(FieldKey key) {
    final field = fields[key];
    if (field == null) return;
    field.reset();
  }

  /// Resets all fields in the form.
  void reset() {
    startTransition(() {
      for (final key in fields.keys) {
        resetField(key);
      }
    });
  }
}

/// Mixin that provides a method to reset a form field.
mixin FormFieldResetter<T> on BaseFormField<T> {
  /// Resets the field to its initial value.
  void reset() {
    startTransition(() {
      value = initialValue;
      context.tryCast<FormValidator>()?.setFieldError(key, null);
      context.tryCast<FormDirty>()?._setDirtyField(key, value != initialValue);
    });
  }
}
