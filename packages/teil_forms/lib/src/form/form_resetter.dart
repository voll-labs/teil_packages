part of 'form.dart';

/// Mixin that provides a method to reset a form field.
mixin FormResetter<F extends FormFieldResetter> on FormController<F> {
  /// Resets the field state.
  ///
  /// If [field] is provided, the field will be reset to its value.
  ///
  /// If [FieldKey] is provided, the field with the given key will be reset to its initial value.
  void resetField({FieldKey? key, F? field}) {
    assert(key != null || field != null, 'Either key or field must be provided.');
    final fieldKey = key ?? field?.key;

    if (fieldKey != null) {
      final current = fields[fieldKey];
      assert(current != null, 'Field with key $fieldKey not found.');
      return current?.reset(field);
    }
  }

  /// Resets the fields state.
  ///
  /// If [fields] is provided, only the fields with the given keys will be reset to their value.
  /// Otherwise, all fields will be reset to their initial value.
  void reset({Set<F>? fields}) {
    if (fields != null) {
      for (final field in fields) {
        resetField(field: field);
      }
      return;
    }

    for (final field in _fields.values) {
      resetField(key: field.key);
    }
  }
}

/// Mixin that provides a method to reset a form field.
@optionalTypeArgs
mixin FormFieldResetter<T> on BaseFormField<T> {
  /// Resets the field state.
  ///
  /// If [field] is provided, the field will be reset to its value.
  void reset([covariant BaseFormField<T>? field]) {
    T newValue;
    if (field != null) {
      newValue = field.value;
    } else {
      newValue = initialValue;
    }

    value = newValue;
    initialValue = newValue;

    startTransition(() {
      tryCast<FormFieldValidator>()?.setError(null);
      tryCast<FormFieldDirty>()?._verifyDirty();
    });
  }
}
