// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_params_example_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryParamsExampleModel _$QueryParamsExampleModelFromJson(
        Map<String, dynamic> json) =>
    QueryParamsExampleModel(
      email: json['email'] as String?,
      company: json['company'] == null
          ? null
          : KeyValueModel.fromJson(json['company'] as Map<String, dynamic>),
      agreeTerms: json['agreeTerms'] as bool? ?? false,
    );

Map<String, dynamic> _$QueryParamsExampleModelToJson(
        QueryParamsExampleModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'company': instance.company,
      'agreeTerms': instance.agreeTerms,
    };
