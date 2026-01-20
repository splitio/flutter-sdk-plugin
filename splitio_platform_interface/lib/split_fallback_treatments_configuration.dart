import 'package:splitio_platform_interface/split_fallback_treatment.dart';

class FallbackTreatmentsConfiguration {
  Map<String, String?>? _global;
  Map<String, Map<String, String?>>? _byFlag;

  Map<String, String?>? get global => _global;
  Map<String, Map<String, String?>>? get byFlag => _byFlag;

  FallbackTreatmentsConfiguration(
      {FallbackTreatment? global, Map<String, FallbackTreatment>? byFlag}) {
    _global = global != null
        ? {'treatment': global.treatment, 'config': global.config}
        : null;
    _byFlag = byFlag?.map((key, value) =>
        MapEntry(key, {'treatment': value.treatment, 'config': value.config}));
  }
}
