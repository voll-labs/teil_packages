part of 'form.dart';

/// Base class for form controllers.
abstract class FormController<F extends BaseFormField> extends TransitionNotifier
    with Diagnosticable {
  /// Creates a [FormController].
  FormController();

  final Map<FieldKey, F> _fields = {};

  /// The fields of the [FormController].
  @protected
  Map<FieldKey, F> get fields => UnmodifiableMapView(_fields);

  /// Cast the [FormController] to a specific type.
  @protected
  C cast<C extends FormController>() => this as C;

  /// Try to cast the [FormController] to a specific type.
  @protected
  C? tryCast<C extends FormController>() => this is C ? cast<C>() : null;

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