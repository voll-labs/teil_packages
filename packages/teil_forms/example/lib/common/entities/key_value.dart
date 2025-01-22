import 'package:flutter/material.dart';

@immutable
class KeyValue {
  final String id;

  final String value;

  const KeyValue({required this.id, required this.value});

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeyValue && other.id == id && other.value == value;
  }

  @override
  int get hashCode => id.hashCode ^ value.hashCode;
}
