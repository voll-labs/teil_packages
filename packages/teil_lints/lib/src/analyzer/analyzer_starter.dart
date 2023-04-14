import 'dart:isolate';

import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/starter.dart';
import 'package:teil_lints/src/analyzer.dart';

/// Teil analyzer plugin starter
class AnalyzerStarter implements ServerPluginStarter {
  AnalyzerStarter._();

  /// The singleton instance of this class.
  static final AnalyzerStarter instance = AnalyzerStarter._();

  @override
  void start(SendPort sendPort) {
    final plugin = AnalyzerPlugin(PhysicalResourceProvider.INSTANCE);
    ServerPluginStarter(plugin).start(sendPort);
  }
}
