/// Represents the result of an evaluation, alongside the split's configuration.
///
/// The [treatment] field contains the result of the evaluation.
///
/// The [config] contains the configuration for the split, if any. May be null.
class SplitResult {
  final String treatment;
  final String? config;

  const SplitResult(this.treatment, this.config);

  @override
  String toString() {
    return '{"treatment": "' +
        treatment +
        '", config: "' +
        (config ?? 'null') +
        '"}';
  }
}
