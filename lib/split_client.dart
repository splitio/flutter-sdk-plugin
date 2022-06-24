import 'package:flutter/services.dart';
import 'package:splitio/split_result.dart';

class SplitClient {
  static const MethodChannel _channel = MethodChannel('splitio');

  static const String _controlTreatment = 'control';
  static const SplitResult _controlResult =
      SplitResult(_controlTreatment, null);

  final String matchingKey;
  final String? bucketingKey;

  const SplitClient(this.matchingKey, this.bucketingKey);

  Future<String> getTreatment(String splitName,
      [Map<String, dynamic> attributes = const {}]) async {
    return await _channel.invokeMethod(
            'getTreatment',
            _buildParameters(
                {'splitName': splitName, 'attributes': attributes})) ??
        _controlTreatment;
  }

  Future<SplitResult> getTreatmentWithConfig(String splitName,
      [Map<String, dynamic> attributes = const {}]) async {
    var treatment = await _channel.invokeMethod('getTreatmentWithConfig',
        _buildParameters({'splitName': splitName, 'attributes': attributes}));

    if (treatment == null) {
      return _controlResult;
    }

    return SplitResult(treatment['treatment'], treatment['config']);
  }

  Future<Map<String, String>> getTreatments(List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) async {
    Map<String, String> result = {};

    Map<Object?, Object?>? treatments = await _channel.invokeMethod(
        'getTreatments',
        _buildParameters({'splitName': splitNames, 'attributes': attributes}));

    if (treatments == null) {
      for (var element in splitNames) {
        result[element] = _controlTreatment;
      }
    } else {
      treatments.forEach((key, value) {
        if (key is String && value is String) {
          result[key] = value;
        }
      });
    }

    return result;
  }

  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) async {
    Map<String, SplitResult> result = {};
    Map<Object?, Object?> treatments = await _channel.invokeMethod(
        'getTreatmentsWithConfig',
        _buildParameters({'splitName': splitNames, 'attributes': attributes}));

    treatments.forEach((key, value) {
      if (key is String && value is Map) {
        result[key] = SplitResult(value['treatment'], value['config']);
      }
    });

    return result;
  }

  Future<bool> track(String eventType,
      {String? trafficType,
      double? value,
      Map<String, dynamic> properties = const {}}) async {
    // TODO implement
    return false;
  }

  Future<bool> setAttribute(String attributeName, dynamic value) async {
    // TODO implement
    return false;
  }

  dynamic getAttribute(String attributeName) async {
    // TODO implement
    return null;
  }

  Future<bool> setAttributes(Map<String, dynamic> attributes) async {
    // TODO implement
    return false;
  }

  Future<Map<String, dynamic>> getAllAttributes() async {
    // TODO implement
    return {};
  }

  Future<bool> removeAttribute(String attributeName) async {
    // TODO implement
    return false;
  }

  Future<bool> clearAttributes() async {
    // TODO implement
    return false;
  }

  Future<void> destroy() async {
    // TODO implement
  }

  Map<String, String> _getKeysMap() {
    Map<String, String> result = {'matchingKey': matchingKey};

    if (bucketingKey != null) {
      result.addAll({'bucketingKey': bucketingKey!});
    }

    return result;
  }

  Map<String, dynamic> _buildParameters(Map<String, dynamic> parameters) {
    var result = parameters;
    result.addAll(_getKeysMap());

    return result;
  }
}
