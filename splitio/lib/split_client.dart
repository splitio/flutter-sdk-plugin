import 'package:splitio_platform_interface/splitio_platform_interface.dart';

abstract class SplitClient {
  /// Performs an evaluation for the [featureFlagName] feature flag.
  ///
  /// This method returns the string 'control' if: there was an exception in
  /// evaluating the feature flag, the SDK does not know of the existence of this
  /// feature flag, and/or the feature flag was deleted through the Split user interface.
  ///
  /// The SDK returns the default treatment of this feature flag if: The feature flag was
  /// killed, or the key did not match any of the conditions in the feature flag
  /// roll-out plan.
  ///
  /// [featureFlagName] is the feature flag we want to evaluate.
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  ///
  /// Returns the evaluated treatment, the default treatment of this feature flag, or 'control'.
  Future<String> getTreatment(String featureFlagName,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]);

  /// Performs and evaluation and returns a [SplitResult] object for the
  /// [featureFlagName] feature flag. This object contains the treatment alongside the
  /// feature flag's configuration, if any.
  ///
  /// This method returns 'control' if: there was an exception in
  /// evaluating the treatment, the SDK does not know of the existence of this
  /// feature flag, and/or the feature flag was deleted through the Split user interface.
  ///
  /// The SDK returns the default treatment of this feature flag if: The feature flag was
  /// killed, or the key did not match any of the conditions in the feature flag
  /// roll-out plan.
  ///
  /// [featureFlagName] is the feature flag we want to evaluate.
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  Future<SplitResult> getTreatmentWithConfig(String featureFlagName,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]);

  /// Convenience method to perform multiple evaluations. Returns a [Map] in
  /// which the keys are feature flag names and the values are treatments.
  ///
  /// A list of feature flag names need to be specified in [featureFlagNames].
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  Future<Map<String, String>> getTreatments(List<String> featureFlagNames,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]);

  /// Convenience method to perform multiple evaluations by flag set. Returns a [Map] in
  /// which the keys are feature flag names and the values are treatments.
  ///
  /// A flag set needs to be specified in [flagSet].
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  Future<Map<String, String>> getTreatmentsByFlagSet(String flagSet,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]);

  /// Convenience method to perform multiple evaluations by flag sets. Returns a [Map] in
  /// which the keys are feature flag names and the values are treatments.
  ///
  /// A list of flag sets needs to be specified in [flagSets].
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  Future<Map<String, String>> getTreatmentsByFlagSets(List<String> flagSets,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]);

  /// Convenience method to perform multiple evaluations by flag set. Returns a [Map] in
  /// which the keys are feature flag names and the values are [SplitResult] objects.
  ///
  /// A flag set needs to be specified in [flagSet].
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  Future<Map<String, SplitResult>> getTreatmentsWithConfigByFlagSet(
      String flagSet,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]);

  /// Convenience method to perform multiple evaluations by flag sets. Returns a [Map] in
  /// which the keys are feature flag names and the values are [SplitResult] objects.
  ///
  /// A list of flag sets needs to be specified in [flagSets].
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  Future<Map<String, SplitResult>> getTreatmentsWithConfigByFlagSets(
      List<String> flagSets,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]);

  /// Convenience method to perform multiple evaluations. Returns a [Map] in
  /// which the keys are feature flag names and the values are [SplitResult] objects.
  ///
  /// A list of feature flag names need to be specified in [featureFlagNames].
  ///
  /// Optionally, a [Map] can be specified with the [attributes] parameter to
  /// take into account when evaluating.
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      List<String> featureFlagNames,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]);

  /// Enqueue a new event to be sent to Split data collection services.
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
  /// new feature flags or modifying segments.
  Stream<SplitClient> whenUpdated();

  /// Returns Future that is completed if the SDK has not been able to get ready in time.
  Future<SplitClient> whenTimeout();
}

class DefaultSplitClient implements SplitClient {
  final SplitioPlatform _platform;
  final String _matchingKey;
  final String? _bucketingKey;

  DefaultSplitClient(this._platform, this._matchingKey, this._bucketingKey);

  @override
  Future<String> getTreatment(String featureFlagName,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions =
          const EvaluationOptions.empty()]) async {
    return _platform.getTreatment(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        splitName: featureFlagName,
        attributes: attributes,
        evaluationOptions: evaluationOptions);
  }

  @override
  Future<SplitResult> getTreatmentWithConfig(String featureFlagName,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions =
          const EvaluationOptions.empty()]) async {
    return _platform.getTreatmentWithConfig(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        splitName: featureFlagName,
        attributes: attributes,
        evaluationOptions: evaluationOptions);
  }

  @override
  Future<Map<String, String>> getTreatments(List<String> featureFlagNames,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions =
          const EvaluationOptions.empty()]) async {
    return _platform.getTreatments(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        splitNames: featureFlagNames,
        attributes: attributes,
        evaluationOptions: evaluationOptions);
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      List<String> featureFlagNames,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions =
          const EvaluationOptions.empty()]) async {
    return _platform.getTreatmentsWithConfig(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        splitNames: featureFlagNames,
        attributes: attributes,
        evaluationOptions: evaluationOptions);
  }

  @override
  Future<Map<String, String>> getTreatmentsByFlagSet(String flagSet,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]) {
    return _platform.getTreatmentsByFlagSet(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        flagSet: flagSet,
        attributes: attributes,
        evaluationOptions: evaluationOptions);
  }

  @override
  Future<Map<String, String>> getTreatmentsByFlagSets(List<String> flagSets,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]) {
    return _platform.getTreatmentsByFlagSets(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        flagSets: flagSets,
        attributes: attributes,
        evaluationOptions: evaluationOptions);
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfigByFlagSet(
      String flagSet,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]) {
    return _platform.getTreatmentsWithConfigByFlagSet(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        flagSet: flagSet,
        attributes: attributes,
        evaluationOptions: evaluationOptions);
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfigByFlagSets(
      List<String> flagSets,
      [Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()]) {
    return _platform.getTreatmentsWithConfigByFlagSets(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        flagSets: flagSets,
        attributes: attributes,
        evaluationOptions: evaluationOptions);
  }

  @override
  Future<bool> track(String eventType,
      {String? trafficType,
      double? value,
      Map<String, dynamic> properties = const {}}) async {
    return _platform.track(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        eventType: eventType,
        trafficType: trafficType,
        value: value,
        properties: properties);
  }

  @override
  Future<bool> setAttribute(String attributeName, dynamic value) async {
    return _platform.setAttribute(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        attributeName: attributeName,
        value: value);
  }

  @override
  Future<dynamic> getAttribute(String attributeName) async {
    return _platform.getAttribute(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        attributeName: attributeName);
  }

  @override
  Future<bool> setAttributes(Map<String, dynamic> attributes) async {
    return _platform.setAttributes(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        attributes: attributes);
  }

  @override
  Future<Map<String, dynamic>> getAttributes() async {
    return _platform.getAllAttributes(
        matchingKey: _matchingKey, bucketingKey: _bucketingKey);
  }

  @override
  Future<bool> removeAttribute(String attributeName) async {
    return _platform.removeAttribute(
        matchingKey: _matchingKey,
        bucketingKey: _bucketingKey,
        attributeName: attributeName);
  }

  @override
  Future<bool> clearAttributes() async {
    return _platform.clearAttributes(
        matchingKey: _matchingKey, bucketingKey: _bucketingKey);
  }

  @override
  Future<void> flush() async {
    return _platform.flush(
        matchingKey: _matchingKey, bucketingKey: _bucketingKey);
  }

  @override
  Future<void> destroy() async {
    return _platform.destroy(
        matchingKey: _matchingKey, bucketingKey: _bucketingKey);
  }

  @override
  Future<SplitClient> whenReady() async {
    await _platform.onReady(
        matchingKey: _matchingKey, bucketingKey: _bucketingKey);

    return Future.value(this);
  }

  @override
  Future<SplitClient> whenReadyFromCache() async {
    await _platform.onReadyFromCache(
        matchingKey: _matchingKey, bucketingKey: _bucketingKey);

    return Future.value(this);
  }

  @override
  Stream<SplitClient> whenUpdated() {
    return _platform
            .onUpdated(matchingKey: _matchingKey, bucketingKey: _bucketingKey)
            ?.map((event) => this) ??
        const Stream.empty();
  }

  @override
  Future<SplitClient> whenTimeout() async {
    await _platform.onTimeout(
        matchingKey: _matchingKey, bucketingKey: _bucketingKey);

    return Future.value(this);
  }
}
