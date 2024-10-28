import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:teil_forms/src/entities/transition_notifier.dart';

part 'form_context.dart';
part 'form_dirty.dart';
part 'form_field.dart';
part 'form_focusable.dart';
part 'form_resetter.dart';
part 'form_submission.dart';
part 'form_validator.dart';

/// A form controller.
abstract class TeilFormController<F extends TeilFormState> extends FormContext<F>
    with FormValidator<F>, FormResetter<F>, FormSubmission<F>, FormDirty<F> {}

/// A form field.
class TeilFormState<T> extends BaseFormField<T>
    with FormFieldFocusable<T>, FormFieldValidator<T>, FormFieldResetter<T>, FormFieldDirty<T> {
  /// Create a form field.
  TeilFormState(super.value);
}
