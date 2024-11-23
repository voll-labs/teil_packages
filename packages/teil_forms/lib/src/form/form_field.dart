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

  /// The [FormController] this field is bound to.
  @protected
  @mustCallSuper
  FormController get context {
    assert(_context != null, 'Field $key is not registered to a form context.');
    return _context!;
  }

  /// Whether the field is bound to a [FormController].
  @protected
  bool get bound => _context != null;

  /// Bind the field [context] to the [FormController].
  @protected
  @mustCallSuper
  void bind(FormController value) {
    assert(_context == null, 'Field $key is already registered to a form context.');
    _context = value;
  }

  /// Unbind the field [context] from the [FormController].
  @protected
  @mustCallSuper
  void unbind() => _context = null;

  /// Cast the [BaseFormField] to a specific type.
  @protected
  F call<F extends BaseFormField>() {
    final field = tryCast<F>();
    assert(field == null, 'Field is not of type $F');
    return field!;
  }

  /// Try to cast the [BaseFormField] to a specific type.
  @protected
  F? tryCast<F extends BaseFormField>() => this is F ? this as F : null;

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
