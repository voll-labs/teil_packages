import 'package:example/common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:teil_forms/teil_forms.dart';

@optionalTypeArgs
sealed class QueryParamsField<T> extends TeilFormField<T> {
  QueryParamsField(super.value);
}

final class EmailField extends QueryParamsField<String?> with ControlledTextField {
  EmailField(super.value);
}

final class CompanyField extends QueryParamsField<KeyValue?> {
  CompanyField(super.value);
}

final class AgreeTermsField extends QueryParamsField<bool> {
  AgreeTermsField({bool? value}) : super(value ?? false);
}
