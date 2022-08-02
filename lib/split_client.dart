import 'package:flutter/services.dart';
import 'package:splitio/split_native_method_parser.dart';
import 'package:splitio/split_result.dart';

class SplitClient {
  static const MethodChannel _channel = MethodChannel('splitio');

  static const String _controlTreatment = 'control';
  static const SplitResult _controlResult =
      SplitResult(_controlTreatment, null);

  final String _matchingKey;
  final String? _bucketingKey;

  late final SplitEventsCallbackManager nativeMethodParser;

  SplitClient(this._matchingKey, this._bucketingKey,
      SplitEventsCallbackManager callbackManager) {
    nativeMethodParser = callbackManager;
    nativeMethodParser.register(_matchingKey, _bucketingKey);
  }

  /// Performs an evaluation for the [splitName] feature.
  ///
  /// This method returns the string 'control' if: there was an exception in
  /// evaluating the feature, the SDK does not know of the existence of this
  /// feature, and/or the feature was deleted through the web console.
  ///
  /// The sdk returns the default treatment of this feature if: The feature was
  /// killed, or the key did not match any of the conditions in the feature
  /// roll-out plan.
  ///
  /// [splitName] is the feature we want to evaluate.
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  ///
  /// Returns the evaluated treatment, the default treatment of this feature, or 'control'.
  Future<String> getTreatment(String splitName,
      [Map<String, dynamic> attributes = const {}]) async {
    return await _channel.invokeMethod(
            'getTreatment',
            _buildParameters(
                {'splitName': splitName, 'attributes': attributes})) ??
        _controlTreatment;
  }

  /// Performs and evaluation and returns a [SplitResult] object for the
  /// [splitName] feature. This object contains the treatment alongside the
  /// split's configuration, if any.
  ///
  /// This method returns 'control' if: there was an exception in
  /// evaluating the treatment, the SDK does not know of the existence of this
  /// feature, and/or the feature was deleted through the web console.
  ///
  /// The sdk returns the default treatment of this feature if: The feature was
  /// killed, or the key did not match any of the conditions in the feature
  /// roll-out plan.
  ///
  /// [splitName] is the feature we want to evaluate.
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
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

  /// Convenience method to perform multiple evaluations. Returns a [Map] in
  /// which the keys are split names and the values are treatments.
  ///
  /// A list of splits need to be specified in [splitNames].
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  Future<Map<String, String>> getTreatments(List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) async {
    Map? treatments = await _channel.invokeMapMethod('getTreatments',
        _buildParameters({'splitName': splitNames, 'attributes': attributes}));

    return treatments
            ?.map((key, value) => MapEntry<String, String>(key, value)) ??
        {for (var item in splitNames) item: _controlTreatment};
  }

  /// Convenience method to perform multiple evaluations. Returns a [Map] in
  /// which the keys are split names and the values are [SplitResult] objects.
  ///
  /// A list of splits need to be specified in [splitNames].
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) async {
    Map? treatments = await _channel.invokeMapMethod('getTreatmentsWithConfig',
        _buildParameters({'splitName': splitNames, 'attributes': attributes}));

    return treatments?.map((key, value) =>
            MapEntry(key, SplitResult(value['treatment'], value['config']))) ??
        {for (var item in splitNames) item: _controlResult};
  }

  /// Enqueue a new event to be sent to split data collection services.
  ///
  /// [eventType] is a [String] representing the event type.
  ///
  /// [trafficType] optionally specifies which traffic type this event belongs
  /// to.
  ///
  /// A [value] can be specified if desired.
  ///
  /// A [Map] of custom properties can be specified in [properties].
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

  /// Stores a custom attribute value to be used in all evaluations.
  ///
  /// Specify the attribute's name with [attributeName], and its value in
  /// [value].
  ///
  /// Returns [true] if the operation was successful; false otherwise.
  Future<bool> setAttribute(String attributeName, dynamic value) async {
    var result = await _channel.invokeMethod('setAttribute',
        _buildParameters({'attributeName': attributeName, 'value': value}));

    if (result is bool) {
      return result;
    }

    return false;
  }

  /// Retrieves an attribute previously saved.
  ///
  /// [attributeName] is the name of the attribute.
  Future<dynamic> getAttribute(String attributeName) async {
    return _channel.invokeMethod(
        'getAttribute', _buildParameters({'attributeName': attributeName}));
  }

  /// Stores a set of custom attributes to be used in all evaluations.
  ///
  /// Specify a [Map] of attributes in [attributes].
  ///
  /// Returns [true] if the operation was successful; false otherwise.
  Future<bool> setAttributes(Map<String, dynamic> attributes) async {
    var result = await _channel.invokeMethod(
        'setAttributes', _buildParameters({'attributes': attributes}));

    if (result is bool) {
      return result;
    }

    return false;
  }

  /// Retrieves a [Map] of every attribute currently bound. Keys are attribute
  /// names, and values their respective values.
  Future<Map<String, dynamic>> getAttributes() async {
    return (await _channel.invokeMapMethod(
                'getAllAttributes', _buildParameters()))
            ?.map((key, value) => MapEntry<String, Object?>(key, value)) ??
        {};
  }

  /// Removes a specific attribute from storage.
  ///
  /// Specify the attribute to be removed using [attributeName].
  ///
  /// Returns [true] if the operation was successful; false otherwise.
  Future<bool> removeAttribute(String attributeName) async {
    return await _channel.invokeMethod(
        'removeAttribute', _buildParameters({'attributeName': attributeName}));
  }

  /// Removes all bound attributes.
  ///
  /// Returns [true] if the operation was successful; false otherwise.
  Future<bool> clearAttributes() async {
    return await _channel.invokeMethod('clearAttributes', _buildParameters());
  }

  /// Forces the client to upload all queued events and impressions.
  ///
  /// Use only if there's a need to do this on demand. Otherwise, the SDK
  /// performs this automatically.
  Future<void> flush() async {
    return _channel.invokeMethod('flush', _buildParameters());
  }

  /// Removes the client from memory and stops its synchronization tasks.
  Future<void> destroy() async {
    return _channel.invokeMethod('destroy', _buildParameters());
  }

  Future<SplitClient> onReady() {
    return nativeMethodParser.onReady(_matchingKey, _bucketingKey);
  }

  Future<SplitClient> onReadyFromCache() {
    return nativeMethodParser.onReadyFromCache(_matchingKey, _bucketingKey);
  }

  Future<SplitClient> onUpdated() {
    return nativeMethodParser.onUpdated(_matchingKey, _bucketingKey);
  }

  Future<SplitClient> onTimeout() {
    return nativeMethodParser.onTimeout(_matchingKey, _bucketingKey);
  }

  Map<String, String> _getKeysMap() {
    Map<String, String> result = {'matchingKey': _matchingKey};

    if (_bucketingKey != null) {
      result.addAll({'bucketingKey': _bucketingKey!});
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
