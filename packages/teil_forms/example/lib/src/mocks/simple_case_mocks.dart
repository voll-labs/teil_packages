import 'package:example/src/entities/entities.dart';
import 'package:faker/faker.dart';

Future<List<KeyValue>> fetchCompanies() async {
  return Future.delayed(
    const Duration(seconds: 1),
    () => List.generate(
      faker.randomGenerator.integer(10, min: 5),
      (index) => KeyValue(
        id: faker.guid.guid(),
        value: faker.company.name(),
      ),
    ),
  );
}

Future<List<KeyValue>> fetchCompanyPostions() async {
  return Future.delayed(
    const Duration(seconds: 1),
    () => List.generate(
      faker.randomGenerator.integer(10, min: 5),
      (index) => KeyValue(
        id: faker.guid.guid(),
        value: faker.company.position(),
      ),
    ),
  );
}
