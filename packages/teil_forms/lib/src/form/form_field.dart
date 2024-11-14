part of 'form.dart';

/// Field key
typedef FieldKey = String;

/// Base class for form fields.
@optionalTypeArgs
abstract class BaseFormField<T> extends ValueTransitionNotifier<T> with Diagnosticable {
  /// The initial value of the field.
  @protected
  @visibleForTesting
  T initialValue;

  /// Create a form field.
  BaseFormField(super.value) : initialValue = value;

  /// Key to identify the field.
  FieldKey get key => describeIdentity(this);

  FormController? _context;

  /// Whether the field is bound to a [FormController].
  @protected
  bool get bound => _context != null;

  /// The [FormController] this field is registered to.
  @protected
  FormController get context {
    assert(_context != null, 'Field $key is not registered to a form context.');
    return _context!;
  }

  /// Bind the field to a [FormController].
  @protected
  @mustCallSuper
  void bind(FormController value) {
    assert(_context == null, 'Field $key is already registered to a form context.');
    _context = value;
  }

  /// Unbind the field from the current [FormController].
  @protected
  @mustCallSuper
  void unbind() => _context = null;

  /// Cast the [BaseFormField] to a specific type.
  @protected
  F call<F extends BaseFormField>() {
    assert(this is F, 'Field is not of type $F');
    return this as F;
  }

  /// Try to cast the [BaseFormField] to a specific type.
  @protected
  F? tryCast<F extends BaseFormField>() => this is F ? call<F>() : null;

  @override
  @mustCallSuper
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('key', key))
      ..add(DiagnosticsProperty('initialValue', initialValue))
      ..add(DiagnosticsProperty('value', value))
      ..add(DiagnosticsProperty('bound', bound))
      ..add(DiagnosticsProperty('context', _context));
  }
}
