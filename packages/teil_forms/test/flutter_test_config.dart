import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

bool _isLeakTrackingEnabled() {
  if (kIsWeb) return false;

  return const bool.fromEnvironment('LEAK_TRACKING') ||
      (bool.tryParse(Platform.environment['LEAK_TRACKING'] ?? '') ?? false);
}

FutureOr<void> testExecutable(FutureOr<void> Function() testMain) {
  if (_isLeakTrackingEnabled()) {
    LeakTesting.enable();
    LeakTracking.warnForUnsupportedPlatforms = false;
    LeakTesting.settings = LeakTesting.settings.withIgnored(createdByTestHelpers: true);
  }

  return testMain();
}
