import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';

// TODO(VictorOhashi): Implement custom plugin
// https://dart.dev/guides/language/analysis-options#plugins

/// Teil analyzer plugin
class AnalyzerPlugin extends ServerPlugin {
  /// Create an instance of [AnalyzerPlugin]
  AnalyzerPlugin(ResourceProvider resourceProvider)
      : super(resourceProvider: resourceProvider);

  @override
  List<String> get fileGlobsToAnalyze => const ['*.dart'];

  @override
  String get contactInfo => 'https://github.com/voll-labs/teil_tools/issues';

  @override
  String get name => 'TeilLints';

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
