/// Fallback treatment for when the feature flag cannot be evaluated.
class FallbackTreatment {
  /// The treatment value.
  final String treatment;

  /// The treatment configuration.
  final String? config;

  /// Creates a new FallbackTreatment instance.
  const FallbackTreatment(this.treatment, [this.config]);
}
