import 'dart:isolate';

import 'package:teil_lints/teil_lints.dart';

void main(_, SendPort sendPort) {
  AnalyzerStarter.instance.start(sendPort);
}
