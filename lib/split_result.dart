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
