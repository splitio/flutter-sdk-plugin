import 'package:flutter/foundation.dart';
import 'package:splitio/channel/method_channel_manager.dart';
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
  Stream<SplitClient> whenUpdated();

  /// Returns Future that is completed if the SDK has not been able to get ready in time.
  Future<SplitClient> whenTimeout();
}

class DefaultSplitClient implements SplitClient {
  static const String _controlTreatment = 'control';
  static const SplitResult _controlResult =
      SplitResult(_controlTreatment, null);

  final MethodChannelManager _methodChannelManager;
  late final SplitEventMethodCallHandler _methodCallHandler;
  final String _matchingKey;
  final String? _bucketingKey;

  late final SplitEventsListener _splitEventsListener;

  DefaultSplitClient(
      this._methodChannelManager, this._matchingKey, this._bucketingKey) {
    _methodCallHandler =
        SplitEventMethodCallHandler(_matchingKey, _bucketingKey, this);
    _splitEventsListener =
        DefaultEventsListener(_methodChannelManager, _methodCallHandler);
  }

  @visibleForTesting
  DefaultSplitClient.withEventListener(this._methodChannelManager,
      this._matchingKey, this._bucketingKey, this._splitEventsListener);

  @override
  Future<String> getTreatment(String splitName,
      [Map<String, dynamic> attributes = const {}]) async {
    return _methodChannelManager.getTreatment(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        splitName: splitName,
        attributes: attributes);
    // TODO return await _methodChannelManager.invokeMethod(
    // TODO         'getTreatment',
    // TODO         _buildParameters(
    // TODO             {'splitName': splitName, 'attributes': attributes})) ??
    // TODO     _controlTreatment;
  }

  @override
  Future<SplitResult> getTreatmentWithConfig(String splitName,
      [Map<String, dynamic> attributes = const {}]) async {
    return _methodChannelManager.getTreatmentWithConfig(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        splitName: splitName,
        attributes: attributes);
    // TODO Map? treatment = (await _methodChannelManager.invokeMapMethod(
    // TODO         'getTreatmentWithConfig',
    // TODO         _buildParameters(
    // TODO             {'splitName': splitName, 'attributes': attributes})))
    // TODO     ?.entries
    // TODO     .first
    // TODO     .value;
    // TODO if (treatment == null) {
    // TODO   return _controlResult;
    // TODO }
    // TODO
    // TODO return SplitResult(treatment['treatment'], treatment['config']);
  }

  @override
  Future<Map<String, String>> getTreatments(List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) async {
    return _methodChannelManager.getTreatments(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        splitNames: splitNames,
        attributes: attributes);
    // TODO Map? treatments = await _methodChannelManager.invokeMapMethod(
    // TODO     'getTreatments',
    // TODO     _buildParameters({'splitName': splitNames, 'attributes': attributes}));
    // TODO
    // TODO return treatments
    // TODO         ?.map((key, value) => MapEntry<String, String>(key, value)) ??
    // TODO     {for (var item in splitNames) item: _controlTreatment};
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) async {
    return _methodChannelManager.getTreatmentsWithConfig(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        splitNames: splitNames,
        attributes: attributes);
    // TODO Map? treatments = await _methodChannelManager.invokeMapMethod(
    // TODO     'getTreatmentsWithConfig',
    // TODO     _buildParameters({'splitName': splitNames, 'attributes': attributes}));
    // TODO
    // TODO return treatments?.map((key, value) =>
    // TODO         MapEntry(key, SplitResult(value['treatment'], value['config']))) ??
    // TODO     {for (var item in splitNames) item: _controlResult};
  }

  @override
  Future<bool> track(String eventType,
      {String? trafficType,
      double? value,
      Map<String, dynamic> properties = const {}}) async {
    return _methodChannelManager.track(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        eventType: eventType,
        trafficType: trafficType,
        value: value,
        properties: properties);
    // TODO var parameters = _buildParameters({'eventType': eventType});
    // TODO
    // TODO if (trafficType != null) {
    // TODO   parameters['trafficType'] = trafficType;
    // TODO }
    // TODO
    // TODO if (value != null) {
    // TODO   parameters['value'] = value;
    // TODO }
    // TODO
    // TODO try {
    // TODO   return await _methodChannelManager.invokeMethod("track", parameters)
    // TODO       as bool;
    // TODO } on Exception catch (_) {
    // TODO   return false;
    // TODO }
  }

  @override
  Future<bool> setAttribute(String attributeName, dynamic value) async {
    return _methodChannelManager.setAttribute(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        attributeName: attributeName,
        value: value);
    // TODO var result = await _methodChannelManager.invokeMethod('setAttribute',
    // TODO     _buildParameters({'attributeName': attributeName, 'value': value}));
    // TODO
    // TODO if (result is bool) {
    // TODO   return result;
    // TODO }
    // TODO
    // TODO return false;
  }

  @override
  Future<dynamic> getAttribute(String attributeName) async {
    return _methodChannelManager.getAttribute(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        attributeName: attributeName);
    // TODO return _methodChannelManager.invokeMethod(
    // TODO     'getAttribute', _buildParameters({'attributeName': attributeName}));
  }

  @override
  Future<bool> setAttributes(Map<String, dynamic> attributes) async {
    return _methodChannelManager.setAttributes(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        attributes: attributes);
    // TODO var result = await _methodChannelManager.invokeMethod(
    // TODO     'setAttributes', _buildParameters({'attributes': attributes}));
    // TODO
    // TODO if (result is bool) {
    // TODO   return result;
    // TODO }
    // TODO
    // TODO return false;
  }

  @override
  Future<Map<String, dynamic>> getAttributes() async {
    return _methodChannelManager.getAllAttributes(
        matchingKey: _matchingKey, bucketingKey: _bucketingKey);
    // TODO return (await _methodChannelManager.invokeMapMethod(
    // TODO             'getAllAttributes', _buildParameters()))
    // TODO         ?.map((key, value) => MapEntry<String, Object?>(key, value)) ??
    // TODO     {};
  }

  @override
  Future<bool> removeAttribute(String attributeName) async {
    return _methodChannelManager.removeAttribute(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        attributeName: attributeName);
  }

  @override
  Future<bool> clearAttributes() async {
    return _methodChannelManager.clearAttributes(
        matchingKey: _matchingKey, bucketingKey: _bucketingKey);
  }

  @override
  Future<void> flush() async {
    return _methodChannelManager.flush(
        matchingKey: _matchingKey, bucketingKey: _bucketingKey);
  }

  @override
  Future<void> destroy() async {
    _splitEventsListener.destroy();
    return _methodChannelManager.destroy(
        matchingKey: _matchingKey, bucketingKey: _bucketingKey);
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
  Stream<SplitClient> whenUpdated() {
    return _splitEventsListener.onUpdated();
  }

  @override
  Future<SplitClient> whenTimeout() {
    return _splitEventsListener.onTimeout();
  }
}
