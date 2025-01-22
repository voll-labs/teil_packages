import 'package:example/common/common.dart';
import 'package:faker/faker.dart';

late FakerService? _instance;

class FakerService {
  FakerService();

  // ignore: prefer_constructors_over_static_methods
  static FakerService get instance {
    _instance ??= FakerService();
    return _instance!;
  }

  List<KeyValue>? _companies;

  Future<List<KeyValue>> fetchCompanies([String? term]) async {
    _companies ??= List.generate(
      10,
      (index) => KeyValue(id: faker.guid.guid(), value: faker.company.name()),
    );

    return Future.delayed(const Duration(seconds: 1), () {
      if (term == null || term.isEmpty) return _companies!;
      return _companies!.where((c) => c.value.contains(term)).toList();
    });
  }
}
