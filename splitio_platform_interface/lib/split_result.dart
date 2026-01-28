/// Represents the result of an evaluation, alongside the split's configuration.
///
/// The [treatment] field contains the result of the evaluation.
///
/// The [config] contains the configuration for the split, if any. May be null.
class SplitResult {
  /// The treatment of the split.
  final String treatment;

  /// The configuration of the split, if any. May be null.
  final String? config;

  /// Creates a new SplitResult instance.
  const SplitResult(this.treatment, this.config);

  @override
  String toString() {
    return '{"treatment": "' +
        treatment +
        '", config: ' +
        (config != null ? '"$config"' : 'null') +
        '}';
  }
}
