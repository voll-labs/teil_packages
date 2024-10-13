import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

part 'form_controller.dart';
part 'form_field.dart';
part 'form_focusable.dart';
part 'form_submitter.dart';
part 'form_validator.dart';

class TeilFormField<T> extends BaseFormField<T> with FormFieldFocusable<T>, FormFieldValidator<T> {
  TeilFormField(super.value);
}

class TeilFormController<F extends TeilFormField<dynamic>> extends BaseFormController<F>
    with FormControllerSubmitter<F>, FormControllerValidator<F> {
  @override
  Future<void> submit(BuildContext context) async {
    if (isSubmitting) return;

    final isValid = await _validate();
    if (!context.mounted) return;

    if (isValid) return _submit(context);
  }
}
