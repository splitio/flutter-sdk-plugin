import 'package:splitio_platform_interface/split_result.dart';

class FallbackTreatments {
  late Map<String, String?>? _global;
  late Map<String, Map<String, String?>>? _byFlag;

  Map<String, String?>? get global => _global;
  Map<String, Map<String, String?>>? get byFlag => _byFlag;

  FallbackTreatments(
      {SplitResult? global, Map<String, SplitResult>? byFlag}) {
    _global = global != null
        ? {'treatment': global.treatment, 'config': global.config}
        : null;
    _byFlag = byFlag?.map((key, value) =>
        MapEntry(key, {'treatment': value.treatment, 'config': value.config}));
  }
}
