import 'package:flutter/material.dart';

abstract class FieldRegister<T> extends ValueNotifier<T> {
  FieldRegister(super._value);

  String get id => hashCode.toString();

  /// Validate the field
  bool validate(FormContext context);

  /// Set the value of the field
  void didChange(T? value);

  /// Reset the field to its initial value
  void reset();
}

abstract class FormContext {
  List<FieldRegister<dynamic>> get fields;
}

abstract class TeilFormValues {
  List<FieldRegister<dynamic>> get fields;
}
