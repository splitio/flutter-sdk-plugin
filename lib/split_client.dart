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
    Map? treatment = (await _channel.invokeMapMethod(
            'getTreatmentWithConfig',
            _buildParameters(
                {'splitName': splitName, 'attributes': attributes})))
        ?.entries
        .first
        .value;
    if (treatment == null) {
      return _controlResult;
    }

    return SplitResult(treatment['treatment'], treatment['config']);
  }

  Future<Map<String, String>> getTreatments(List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) async {
    Map? treatments = await _channel.invokeMapMethod('getTreatments',
        _buildParameters({'splitName': splitNames, 'attributes': attributes}));

    return treatments
            ?.map((key, value) => MapEntry<String, String>(key, value)) ??
        {for (var item in splitNames) item: _controlTreatment};
  }

  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) async {
    Map? treatments = await _channel.invokeMapMethod('getTreatmentsWithConfig',
        _buildParameters({'splitName': splitNames, 'attributes': attributes}));

    return treatments?.map((key, value) =>
            MapEntry(key, SplitResult(value['treatment'], value['config']))) ??
        {for (var item in splitNames) item: _controlResult};
  }

  Future<bool> track(String eventType,
      {String? trafficType,
      double? value,
      Map<String, dynamic> properties = const {}}) async {
    var parameters = _buildParameters({'eventType': eventType});

    if (trafficType != null) {
      parameters['trafficType'] = trafficType;
    }

    if (value != null) {
      parameters['value'] = value;
    }

    try {
      return await _channel.invokeMethod("track", parameters) as bool;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> setAttribute(String attributeName, dynamic value) async {
    var result = await _channel.invokeMethod('setAttribute',
        _buildParameters({'attributeName': attributeName, 'value': value}));

    if (result is bool) {
      return result;
    }

    return false;
  }

  Future<dynamic> getAttribute(String attributeName) async {
    return _channel.invokeMethod(
        'getAttribute', _buildParameters({'attributeName': attributeName}));
  }

  Future<bool> setAttributes(Map<String, dynamic> attributes) async {
    var result = await _channel.invokeMethod(
        'setAttributes', _buildParameters({'attributes': attributes}));

    if (result is bool) {
      return result;
    }

    return false;
  }

  Future<Map<String, dynamic>> getAttributes() async {
    return (await _channel.invokeMapMethod(
                'getAllAttributes', _buildParameters()))
            ?.map((key, value) => MapEntry<String, Object?>(key, value)) ??
        {};
  }

  Future<bool> removeAttribute(String attributeName) async {
    return await _channel.invokeMethod(
        'removeAttribute', _buildParameters({'attributeName': attributeName}));
  }

  Future<bool> clearAttributes() async {
    return await _channel.invokeMethod('clearAttributes', _buildParameters());
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

  Map<String, dynamic> _buildParameters(
      [Map<String, dynamic> parameters = const {}]) {
    Map<String, dynamic> result = {};
    result.addAll(parameters);
    result.addAll(_getKeysMap());

    return result;
  }
}
