import 'dart:isolate';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/starter.dart';

/// Teil analyzer plugin starter
class AnalyzerStarter implements ServerPluginStarter {
  AnalyzerStarter._();

  /// The singleton instance of this class.
  static final AnalyzerStarter instance = AnalyzerStarter._();

  @override
  void start(SendPort sendPort) {
    final plugin = _AnalyzerPlugin(PhysicalResourceProvider.INSTANCE);
    ServerPluginStarter(plugin).start(sendPort);
  }
}

class _AnalyzerPlugin extends ServerPlugin {
  _AnalyzerPlugin(ResourceProvider resourceProvider)
      : super(resourceProvider: resourceProvider);
  @override
  List<String> get fileGlobsToAnalyze => const ['*.dart'];

  @override
  String get name => 'TeilAnalyzer';

  @override
  String get version => '0.0.1';

  @override
  Future<void> analyzeFile({
    required AnalysisContext analysisContext,
    required String path,
  }) async {
    final isAnalyzed = analysisContext.contextRoot.isAnalyzed(path);
    if (!isAnalyzed) {
      return;
    }

    return;
  }
}
