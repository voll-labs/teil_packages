// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_params_example_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryParamsExampleModel _$QueryParamsExampleModelFromJson(
        Map<String, dynamic> json) =>
    QueryParamsExampleModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      company: json['company'] == null
          ? const KeyValueModel()
          : KeyValueModel.fromJson(json['company'] as Map<String, dynamic>),
      companyPosition: json['companyPosition'] == null
          ? const KeyValueModel()
          : KeyValueModel.fromJson(
              json['companyPosition'] as Map<String, dynamic>),
      radioExample: $enumDecodeNullable(
              _$RadioExampleValueEnumMap, json['radioExample']) ??
          RadioExampleValue.one,
      activeProfile: json['activeProfile'] as bool? ?? false,
      agreeTerms: json['agreeTerms'] as bool? ?? false,
    );

Map<String, dynamic> _$QueryParamsExampleModelToJson(
        QueryParamsExampleModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'company': instance.company,
      'companyPosition': instance.companyPosition,
      'radioExample': _$RadioExampleValueEnumMap[instance.radioExample]!,
      'activeProfile': instance.activeProfile,
      'agreeTerms': instance.agreeTerms,
    };

const _$RadioExampleValueEnumMap = {
  RadioExampleValue.one: 'one',
  RadioExampleValue.two: 'two',
  RadioExampleValue.three: 'three',
};
