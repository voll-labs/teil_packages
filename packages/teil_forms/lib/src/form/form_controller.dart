part of 'form.dart';

/// A map of [FieldKey] to [BaseFormField].
typedef FormFields<F extends BaseFormField> = Map<FieldKey, F>;

/// Base class for form controllers.
abstract class FormController<F extends BaseFormField> extends TransitionNotifier
    with Diagnosticable {
  /// Creates a [FormController].
  FormController();

  final FormFields<F> _fields = {};

  /// The fields of the [FormController].
  @protected
  FormFields<F> get fields => UnmodifiableMapView(_fields);

  /// Register a field to the form controller
  void register(F field) {
    assert(!_fields.containsKey(field.key), 'Field with key ${field.key} already registered.');
    _fields.putIfAbsent(field.key, () => field..bind(this));
  }

  /// Unregister a field from the form controller
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
    assert(this is C, 'FormController of type $runtimeType cannot be cast to $C');
    return this as C;
  }

  /// Try to cast the [FormController] to a specific type.
  @protected
  C? tryCast<C extends FormController>() {
    return this is C ? call<C>() : null;
  }

  @override
  void dispose() {
    _fields.clear();
    super.dispose();
  }

  @override
  @mustCallSuper
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('fields', fields));
  }
}
