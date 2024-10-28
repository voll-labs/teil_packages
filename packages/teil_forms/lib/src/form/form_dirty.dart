part of 'form.dart';

typedef DirtyFields = Set<FieldKey>;

mixin FormDirty<F extends FormFieldDirty> on FormContext<F> {
  final DirtyFields _dirtyFields = {};

  /// The dirty fields of the [FormContext].
  DirtyFields get dirtyFields => UnmodifiableSetView(_dirtyFields);

  bool get isDirty => _dirtyFields.isNotEmpty;

  void _setDirtyField(FieldKey key, bool isDirty) {
    if (isDirty) {
      _dirtyFields.add(key);
    } else {
      _dirtyFields.remove(key);
    }
    notifyListeners();
  }
}

mixin FormFieldDirty<T> on BaseFormField<T> {
  bool _isDirty = false;

  /// Whether the [FormField] is dirty.
  bool get isDirty => _isDirty;

  void _verify() {
    final isDirty = value != initialValue;
    if (_isDirty == isDirty) return;

    _isDirty = isDirty;
    context.cast<FormDirty>()._setDirtyField(key, isDirty);
    notifyListeners();
  }

  @override
  set value(T value) {
    startTransition(() {
      _verify();
      super.value = value;
    });
  }
}
