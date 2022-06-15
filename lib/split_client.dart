import 'package:flutter/services.dart';
import 'package:splitio/split_result.dart';

class SplitClient {
  static const MethodChannel _channel = MethodChannel('splitio');

  static const String _controlTreatment = 'control';
  static const SplitResult _controlResult =
      SplitResult(_controlTreatment, null);

  String matchingKey;
  String? bucketingKey;

  SplitClient(this.matchingKey, this.bucketingKey);

  Future<String> getTreatment(String treatment,
      [Map<String, dynamic> attributes = const {}]) async {
    return ''; //TODO implement
  }

  Future<SplitResult> getTreatmentWithConfig(String treatment,
      [Map<String, dynamic> attributes = const {}]) async {
    return _controlResult; //TODO implement
  }

  Future<Map<String, String>> getTreatments(List<String> treatments,
      [Map<String, dynamic> attributes = const {}]) async {
    Map<String, String> result = {};
    for (String treatment in treatments) {
      result.addAll({treatment: _controlTreatment});
    }

    return Future.value(result); //TODO implement
  }

  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      List<String> treatments,
      [Map<String, dynamic> attributes = const {}]) async {
    Map<String, SplitResult> result = {};
    for (String treatment in treatments) {
      result.addAll({treatment: _controlResult});
    }

    return Future.value(result); //TODO implement
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

  Object? getAttribute(String attributeName) async {
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
      result.addAll({'bucketingKey': bucketingKey ?? ""});
    }

    return result;
  }

  Map<String, dynamic> _buildParameters(Map<String, dynamic> parameters) {
    var result = parameters;
    result.addAll(_getKeysMap());

    return result;
  }
}
