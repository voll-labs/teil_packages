import 'package:faker/faker.dart';

class KeyValue {
  final String id;

  final String value;

  KeyValue({required this.id, required this.value});

  @override
  String toString() => value;
}

class Company extends KeyValue {
  Company({required super.id, required super.value});

  static Future<List<Company>> fetchList() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () => List.generate(
        faker.randomGenerator.integer(10, min: 5),
        (index) => Company(
          id: faker.guid.guid(),
          value: faker.company.name(),
        ),
      ),
    );
  }
}

class CompanyPosition extends KeyValue {
  CompanyPosition({required super.id, required super.value});

  static Future<List<CompanyPosition>> fetchList() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () => List.generate(
        faker.randomGenerator.integer(10, min: 5),
        (index) => CompanyPosition(
          id: faker.guid.guid(),
          value: faker.company.position(),
        ),
      ),
    );
  }
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
