import 'dart:isolate';

import 'package:teil_lints/teil_lints.dart';

void main(List<String> args, SendPort sendPort) {
  AnalyzerStarter.instance.start(sendPort);
}
