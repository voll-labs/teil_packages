import 'dart:convert';

import 'package:example/src/entities/entities.dart';
import 'package:example/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query_params_example_model.g.dart';

@JsonSerializable()
class QueryParamsExampleModel {
  final String? name;

  final String? email;

  final KeyValueModel company;

  final KeyValueModel companyPosition;

  final RadioExampleValue radioExample;

  final bool activeProfile;

  final bool agreeTerms;

  QueryParamsExampleModel({
    this.name,
    this.email,
    this.company = const KeyValueModel(),
    this.companyPosition = const KeyValueModel(),
    this.radioExample = RadioExampleValue.one,
    this.activeProfile = false,
    this.agreeTerms = false,
  });

  factory QueryParamsExampleModel.fromBase64(String? base64) {
    if (base64 == null) return QueryParamsExampleModel();

    final json = jsonDecode(utf8.decode(base64Decode(base64)));
    if (json is! Map<String, dynamic>) return QueryParamsExampleModel();

    return QueryParamsExampleModel.fromJson(json);
  }

  String toBase64() {
    final json = jsonEncode(toJson());
    return base64Encode(utf8.encode(json));
  }

  factory QueryParamsExampleModel.fromJson(Map<String, dynamic> json) =>
      _$QueryParamsExampleModelFromJson(json);

  Map<String, dynamic> toJson() => _$QueryParamsExampleModelToJson(this);
}
