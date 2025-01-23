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
