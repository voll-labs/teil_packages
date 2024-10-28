import 'dart:async';

import 'package:flutter/foundation.dart';

typedef TransitionCallback<T> = FutureOr<T> Function();

/// [ChangeNotifier] that allows transitions to be started.
///
/// See also: [Transition]
class TransitionNotifier extends ChangeNotifier with Transition {
  TransitionNotifier();
}

/// [ValueNotifier] that allows transitions to be started.
///
/// See also: [Transition]
class ValueTransitionNotifier<T> extends ValueNotifier<T> with Transition {
  ValueTransitionNotifier(super.value);
}

/// Mixin that gives a [ChangeNotifier] the ability to start transitions.
mixin Transition on ChangeNotifier {
  int _transitions = 0;

  /// Whether the [ChangeNotifier] is transitioning.
  @protected
  bool get isTransitioning => _transitions > 0;

  bool _pendingNotify = false;

  /// Start a transition and return the result.
  ///
  /// If the [ChangeNotifier] is transitioning, the [ChangeNotifier] will not
  /// notify listeners until the transition is complete.
  @protected
  FutureOr<T> startTransition<T>(TransitionCallback<T> transition) async {
    _transitions++;
    final result = await transition();
    _transitions--;

    if (_pendingNotify) notifyListeners();
    return result;
  }

  @override
  void notifyListeners() {
    _pendingNotify = true;
    if (isTransitioning) return;
    _pendingNotify = false;
    super.notifyListeners();
  }
}
