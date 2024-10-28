part of 'form.dart';

/// Field key
typedef FieldKey = String;

/// Base class for form fields.
abstract class BaseFormField<T> extends ValueTransitionNotifier<T> with Diagnosticable {
  @protected

  /// The initial value of the field.
  final T initialValue;

  /// Create a form field.
  BaseFormField(super.value) : initialValue = value;

  /// Key to identify the field.
  FieldKey get key => describeIdentity(this);

  FormContext? _context;

  /// Whether the field is bound to a [FormContext].
  bool get bound => _context != null;

  /// The [FormContext] this field is registered to.
  @protected
  FormContext get context {
    assert(_context != null, 'Field $key is not registered to a form context.');
    return _context!;
  }

  /// Bind the field to a [FormContext].
  @protected
  @mustCallSuper
  void bind(FormContext value) {
    assert(_context == null, 'Field $key is already registered to a form context.');
    _context = value;
  }

  /// Unbind the field from the current [FormContext].
  @mustCallSuper
  void unbind() => _context = null;

  @override
  @mustCallSuper
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<FieldKey>('key', key))
      ..add(DiagnosticsProperty<bool>('bound', bound));
  }
}
