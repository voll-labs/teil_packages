part of 'form.dart';

/// Signature of [BaseFormField] registered to a [FormController].
typedef FormFields<F extends BaseFormField> = Map<FieldKey, F>;

/// {@template form_controller}
/// Base class for [FormController].
/// {@endtemplate}
abstract class FormController<F extends BaseFormField> extends TransitionNotifier
    with Diagnosticable {
  /// {@macro form_controller}
  FormController();

  final FormFields<F> _fields = {};

  /// The fields registered to the [FormController].
  @protected
  FormFields<F> get fields => UnmodifiableMapView(_fields);

  /// Register the [field] to the [FormController].
  ///
  /// It is **required** to call this method to bind the [BaseFormField.context] to the [FormController].
  /// [FieldBuilder] automatically calls this method when building the field.
  ///
  /// Throws an [AssertionError] if the field is already registered.
  ///
  /// See also: [BaseFormField.context], [unregister]
  void register(F field) {
    if (field.bound) return;
    assert(!_fields.containsKey(field.key), 'Field with key ${field.key} already registered.');
    _fields.putIfAbsent(field.key, () => field..bind(this));
  }

  /// Unregister the [field] from the [FormController].
  ///
  /// Throws an [AssertionError] if the field is not registered.
  void unregister(F field) {
    assert(
      _fields.containsKey(field.key),
      'Field with key ${field.key} not registered.\n'
      'Make sure the field is registered before trying to unregister it.',
    );
    field.unbind();
    _fields.remove(field.key);
  }

  /// Cast the [FormController] to a specific type.
  @protected
  C call<C extends FormController>() {
    final form = tryCast<C>();
    assert(form != null, 'FormController of type $runtimeType cannot be cast to $C');
    return form!;
  }

  /// Try to cast the [FormController] to a specific type.
  @protected
  C? tryCast<C extends FormController>() => this is C ? this as C : null;

  @override
  void dispose() {
    for (final field in _fields.values) {
      field.dispose();
      _fields.remove(field.key);
    }
    super.dispose();
  }

  @override
  @mustCallSuper
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('fields', fields));
  }
}
