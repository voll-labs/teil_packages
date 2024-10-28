part of 'form.dart';

/// The dirty fields of a [FormController].
typedef DirtyFields = Set<FieldKey>;

/// Mixin that provides dirty field tracking for a [FormController].
mixin FormDirty<F extends FormFieldDirty> on FormController<F> {
  final DirtyFields _dirtyFields = {};

  /// The dirty fields of the [FormController].
  DirtyFields get dirtyFields => UnmodifiableSetView(_dirtyFields);

  /// Whether the [FormController] is dirty.
  bool get isDirty => _dirtyFields.isNotEmpty;

  void _setDirtyField(FieldKey key, bool isDirty) {
    if (isDirty) {
      _dirtyFields.add(key);
    } else {
      _dirtyFields.remove(key);
    }
    notifyListeners();
  }

  @override
  @mustCallSuper
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('isDirty', isDirty))
      ..add(DiagnosticsProperty('dirtyFields', dirtyFields));
  }
}

/// Mixin that provides dirty field tracking for a [FormField].
@optionalTypeArgs
mixin FormFieldDirty<T> on BaseFormField<T> {
  bool _isDirty = false;

  /// Whether the [FormField] is dirty.
  bool get isDirty => _isDirty;

  void _verifyDirty() {
    final isDirty = value != initialValue;
    if (_isDirty == isDirty) return;

    _isDirty = isDirty;
    context.cast<FormDirty>()._setDirtyField(key, isDirty);
    notifyListeners();
  }

  @override
  set value(T value) {
    super.value = value;
    _verifyDirty();
  }

  @override
  @mustCallSuper
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('isDirty', isDirty));
  }
}
