part of 'form.dart';

typedef FieldKey = String;

abstract class BaseFormField<T> extends ValueNotifier<T> {
  BaseFormField(super.value);

  FieldKey get key => describeIdentity(this);
}
