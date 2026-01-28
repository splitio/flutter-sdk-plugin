import 'package:splitio_platform_interface/split_fallback_treatment.dart';

/// Configuration for fallback treatments.
class FallbackTreatmentsConfiguration {
  Map<String, String?>? _global;
  Map<String, Map<String, String?>>? _byFlag;

  /// Global fallback treatment.
  Map<String, String?>? get global => _global;

  /// Fallback treatments by flag.
  Map<String, Map<String, String?>>? get byFlag => _byFlag;

  /// Creates a new FallbackTreatmentsConfiguration instance.
  FallbackTreatmentsConfiguration(
      {FallbackTreatment? global, Map<String, FallbackTreatment>? byFlag}) {
    _global = global != null
        ? {'treatment': global.treatment, 'config': global.config}
        : null;
    _byFlag = byFlag?.map((key, value) =>
        MapEntry(key, {'treatment': value.treatment, 'config': value.config}));
  }
}
