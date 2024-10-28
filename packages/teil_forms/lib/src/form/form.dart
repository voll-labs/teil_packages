import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:teil_forms/src/entities/entities.dart';

part 'form_controller.dart';
part 'form_dirty.dart';
part 'form_field.dart';
part 'form_focusable.dart';
part 'form_resetter.dart';
part 'form_submission.dart';
part 'form_validator.dart';

/// A form controller.
abstract class TeilFormController<F extends TeilFormField> extends FormController<F>
    with FormValidator<F>, FormResetter<F>, FormSubmission<F>, FormDirty<F> {}

/// A form field.
@optionalTypeArgs
class TeilFormField<T> extends BaseFormField<T>
    with FormFieldFocusable<T>, FormFieldValidator<T>, FormFieldResetter<T>, FormFieldDirty<T> {
  /// Create a form field.
  TeilFormField(super.value);
}
