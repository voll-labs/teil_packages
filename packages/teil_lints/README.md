# Teil Lints

This package provides lint rules for Dart and Flutter which are used at [Voll](https://conheca.govoll.com/).
Combaning the best practices from [Very Good Analysis](https://pub.dev/packages/very_good_analysis) and [DCM](https://dcm.dev/).

## Usage

To use the lints, add as a dev dependency in your `pubspec.yaml`:

```yaml
dev_dependencies:
  teil_lints: *version
```

Then, add an include in `analysis_options.yaml`:

```yaml
include: package:teil_lints/analysis_options.yaml
```
