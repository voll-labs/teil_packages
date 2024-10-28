part of 'form.dart';

mixin FormResetter<F extends FormFieldResetter> on FormContext<F> {
  void resetField(FieldKey key) {
    final field = fields[key];
    if (field == null) return;
    field.reset();
  }

  void reset() {
    startTransition(() {
      for (final key in fields.keys) {
        resetField(key);
      }
    });
  }
}

mixin FormFieldResetter<T> on BaseFormField<T> {
  void reset() {
    startTransition(() {
      value = initialValue;
      context.tryCast<FormValidator>()?.setFieldError(key, null);
      context.tryCast<FormDirty>()?._setDirtyField(key, value != initialValue);
    });
  }
}
