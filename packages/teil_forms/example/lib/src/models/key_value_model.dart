import 'package:example/example.dart';
import 'package:json_annotation/json_annotation.dart';

part 'key_value_model.g.dart';

@JsonSerializable()
class KeyValueModel extends KeyValue {
  const KeyValueModel({super.id = '', super.value = ''});

  factory KeyValueModel.fromJson(Map<String, dynamic> json) => _$KeyValueModelFromJson(json);

  Map<String, dynamic> toJson() => _$KeyValueModelToJson(this);

  factory KeyValueModel.fromEntity(KeyValue? value) {
    if (value == null) return const KeyValueModel();
    return KeyValueModel(id: value.id, value: value.value);
  }
}
