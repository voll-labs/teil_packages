part of 'form.dart';

abstract class BaseFormController<F extends BaseFormField<dynamic>> extends ChangeNotifier {
  BaseFormController();

  final Map<FieldKey, F> _fields = {};

  @protected
  Map<FieldKey, F> get fields => UnmodifiableMapView(_fields);

  /// Register a field to the form controller
  void register(F field) {
    assert(!_fields.containsKey(field.key), 'Field with key ${field.key} already registered');
    _fields.putIfAbsent(field.key, () => field);
  }

  /// Unregister a field from the form controller
  void unregister(F field) {
    assert(
      _fields.containsKey(field.key),
      'Field with key ${field.key} not registered.\n'
      'Make sure the field is registered before trying to unregister it.',
    );
    _fields.remove(field.key);
  }

  @override
  void dispose() {
    _fields.clear();
    super.dispose();
  }
}
