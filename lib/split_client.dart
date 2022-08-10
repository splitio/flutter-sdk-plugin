import 'package:flutter/foundation.dart';
import 'package:splitio/channel/method_channel_wrapper.dart';
import 'package:splitio/events/split_events_listener.dart';
import 'package:splitio/events/split_method_call_handler.dart';
import 'package:splitio/split_result.dart';

abstract class SplitClient {
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
      [Map<String, dynamic> attributes = const {}]);

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
      [Map<String, dynamic> attributes = const {}]);

  /// Convenience method to perform multiple evaluations. Returns a [Map] in
  /// which the keys are split names and the values are treatments.
  ///
  /// A list of splits need to be specified in [splitNames].
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  Future<Map<String, String>> getTreatments(List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]);

  /// Convenience method to perform multiple evaluations. Returns a [Map] in
  /// which the keys are split names and the values are [SplitResult] objects.
  ///
  /// A list of splits need to be specified in [splitNames].
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]);

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
      Map<String, dynamic> properties = const {}});

  /// Stores a custom attribute value to be used in all evaluations.
  ///
  /// Specify the attribute's name with [attributeName], and its value in
  /// [value].
  ///
  /// Returns [true] if the operation was successful; false otherwise.
  Future<bool> setAttribute(String attributeName, dynamic value);

  /// Retrieves an attribute previously saved.
  ///
  /// [attributeName] is the name of the attribute.
  Future<dynamic> getAttribute(String attributeName);

  /// Stores a set of custom attributes to be used in all evaluations.
  ///
  /// Specify a [Map] of attributes in [attributes].
  ///
  /// Returns [true] if the operation was successful; false otherwise.
  Future<bool> setAttributes(Map<String, dynamic> attributes);

  /// Retrieves a [Map] of every attribute currently bound. Keys are attribute
  /// names, and values their respective values.
  Future<Map<String, dynamic>> getAttributes();

  /// Removes a specific attribute from storage.
  ///
  /// Specify the attribute to be removed using [attributeName].
  ///
  /// Returns [true] if the operation was successful; false otherwise.
  Future<bool> removeAttribute(String attributeName);

  /// Removes all bound attributes.
  ///
  /// Returns [true] if the operation was successful; false otherwise.
  Future<bool> clearAttributes();

  /// Forces the client to upload all queued events and impressions.
  ///
  /// Use only if there's a need to do this on demand. Otherwise, the SDK
  /// performs this automatically.
  Future<void> flush();

  /// Removes the client from memory and stops its synchronization tasks.
  Future<void> destroy();

  /// Returns Future that is completed when the most up-to-date information has been
  /// retrieved from the Split cloud.
  Future<SplitClient> whenReady();

  /// Returns Future that is completed once the SDK has been able to load
  /// definitions from cache. This information is not guaranteed to be the most
  /// up-to-date, but all the functionality will be available.
  Future<SplitClient> whenReadyFromCache();

  /// Returns Future that is completed when changes have been made, such as creating
  /// new splits or modifying segments.
  Future<SplitClient> whenUpdated();

  /// Returns Future that is completed if the SDK has not been able to get ready in time.
  Future<SplitClient> whenTimeout();
}

class DefaultSplitClient extends SplitClient {
  static const String _controlTreatment = 'control';
  static const SplitResult _controlResult =
      SplitResult(_controlTreatment, null);

  final MethodChannelWrapper _methodChannelWrapper;
  final String _matchingKey;
  final String? _bucketingKey;

  late final SplitEventsListener _splitEventsListener;

  DefaultSplitClient(
      this._methodChannelWrapper, this._matchingKey, this._bucketingKey) {
    _splitEventsListener = DefaultEventsListener(_methodChannelWrapper,
        SplitEventMethodCallHandler(_matchingKey, _bucketingKey, this));
  }

  @visibleForTesting
  DefaultSplitClient.withEventListener(this._methodChannelWrapper,
      this._matchingKey, this._bucketingKey, this._splitEventsListener);

  @override
  Future<String> getTreatment(String splitName,
      [Map<String, dynamic> attributes = const {}]) async {
    return await _methodChannelWrapper.invokeMethod(
            'getTreatment',
            _buildParameters(
                {'splitName': splitName, 'attributes': attributes})) ??
        _controlTreatment;
  }

  @override
  Future<SplitResult> getTreatmentWithConfig(String splitName,
      [Map<String, dynamic> attributes = const {}]) async {
    Map? treatment = (await _methodChannelWrapper.invokeMapMethod(
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

  @override
  Future<Map<String, String>> getTreatments(List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) async {
    Map? treatments = await _methodChannelWrapper.invokeMapMethod(
        'getTreatments',
        _buildParameters({'splitName': splitNames, 'attributes': attributes}));

    return treatments
            ?.map((key, value) => MapEntry<String, String>(key, value)) ??
        {for (var item in splitNames) item: _controlTreatment};
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) async {
    Map? treatments = await _methodChannelWrapper.invokeMapMethod(
        'getTreatmentsWithConfig',
        _buildParameters({'splitName': splitNames, 'attributes': attributes}));

    return treatments?.map((key, value) =>
            MapEntry(key, SplitResult(value['treatment'], value['config']))) ??
        {for (var item in splitNames) item: _controlResult};
  }

  @override
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
      return await _methodChannelWrapper.invokeMethod("track", parameters)
          as bool;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Future<bool> setAttribute(String attributeName, dynamic value) async {
    var result = await _methodChannelWrapper.invokeMethod('setAttribute',
        _buildParameters({'attributeName': attributeName, 'value': value}));

    if (result is bool) {
      return result;
    }

    return false;
  }

  @override
  Future<dynamic> getAttribute(String attributeName) async {
    return _methodChannelWrapper.invokeMethod(
        'getAttribute', _buildParameters({'attributeName': attributeName}));
  }

  @override
  Future<bool> setAttributes(Map<String, dynamic> attributes) async {
    var result = await _methodChannelWrapper.invokeMethod(
        'setAttributes', _buildParameters({'attributes': attributes}));

    if (result is bool) {
      return result;
    }

    return false;
  }

  @override
  Future<Map<String, dynamic>> getAttributes() async {
    return (await _methodChannelWrapper.invokeMapMethod(
                'getAllAttributes', _buildParameters()))
            ?.map((key, value) => MapEntry<String, Object?>(key, value)) ??
        {};
  }

  @override
  Future<bool> removeAttribute(String attributeName) async {
    return await _methodChannelWrapper.invokeMethod(
        'removeAttribute', _buildParameters({'attributeName': attributeName}));
  }

  @override
  Future<bool> clearAttributes() async {
    return await _methodChannelWrapper.invokeMethod(
        'clearAttributes', _buildParameters());
  }

  @override
  Future<void> flush() async {
    return _methodChannelWrapper.invokeMethod('flush', _buildParameters());
  }

  @override
  Future<void> destroy() async {
    return _methodChannelWrapper.invokeMethod('destroy', _buildParameters());
  }

  @override
  Future<SplitClient> whenReady() {
    return _splitEventsListener.onReady();
  }

  @override
  Future<SplitClient> whenReadyFromCache() {
    return _splitEventsListener.onReadyFromCache();
  }

  @override
  Future<SplitClient> whenUpdated() {
    return _splitEventsListener.onUpdated();
  }

  @override
  Future<SplitClient> whenTimeout() {
    return _splitEventsListener.onTimeout();
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
