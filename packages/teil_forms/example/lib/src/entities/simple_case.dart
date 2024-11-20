class KeyValue {
  final String id;

  final String value;

  const KeyValue({required this.id, required this.value});

  @override
  String toString() => value;
}

enum RadioExampleValue {
  one,
  two,
  three;

  @override
  String toString() {
    switch (this) {
      case RadioExampleValue.one:
        return 'One';
      case RadioExampleValue.two:
        return 'Two';
      case RadioExampleValue.three:
        return 'Three';
    }
  }
}
