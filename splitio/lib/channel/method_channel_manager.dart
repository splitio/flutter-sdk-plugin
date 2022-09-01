import 'package:splitio/impressions/split_impression.dart';
import 'package:splitio/method_call_handler.dart';
import 'package:splitio/platform/common_platform.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_configuration.dart';
import 'package:splitio/split_result.dart';
import 'package:splitio/split_view.dart';

class MethodChannelManager extends SplitioPlatform {
  final SplitioPlatform _platform;

  MethodChannelManager(this._platform);

  @override
  void addNativeCallHandler(MethodCallHandler handler) {
    _platform.addNativeCallHandler(handler); // TODO
  }

  @override
  void removeNativeCallHandler(MethodCallHandler handler) {
    _platform.removeNativeCallHandler(handler); // TODO
  }

  @override
  Future<bool> clearAttributes(
      {required String matchingKey, required String? bucketingKey}) {
    return _platform.clearAttributes(
        matchingKey: matchingKey, bucketingKey: bucketingKey);
  }

  @override
  Future<void> destroy(
      {required String matchingKey, required String? bucketingKey}) {
    return _platform.destroy(
        matchingKey: matchingKey, bucketingKey: bucketingKey);
  }

  @override
  Future<void> flush(
      {required String matchingKey, required String? bucketingKey}) {
    return _platform.flush(
        matchingKey: matchingKey, bucketingKey: bucketingKey);
  }

  @override
  Future<Map<String, dynamic>> getAllAttributes(
      {required String matchingKey, required String? bucketingKey}) {
    return _platform.getAllAttributes(
        matchingKey: matchingKey, bucketingKey: bucketingKey);
  }

  @override
  Future getAttribute(
      {required String matchingKey,
      required String attributeName,
      required String? bucketingKey}) {
    return _platform.getAttribute(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        attributeName: attributeName);
  }

  @override
  Future<void> getClient({required String matchingKey, String? bucketingKey}) {
    return _platform.getClient(
        matchingKey: matchingKey, bucketingKey: bucketingKey);
  }

  @override
  Future<String> getTreatment(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {}}) {
    return _platform.getTreatment(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        splitName: splitName,
        attributes: attributes);
  }

  @override
  Future<SplitResult> getTreatmentWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {}}) {
    return _platform.getTreatmentWithConfig(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        splitName: splitName,
        attributes: attributes);
  }

  @override
  Future<Map<String, String>> getTreatments(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> splitNames,
      Map<String, dynamic> attributes = const {}}) {
    return _platform.getTreatments(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        splitNames: splitNames,
        attributes: attributes);
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> splitNames,
      Map<String, dynamic> attributes = const {}}) {
    return _platform.getTreatmentsWithConfig(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        splitNames: splitNames,
        attributes: attributes);
  }

  @override
  Future<void> init(
      {required String apiKey,
      required String matchingKey,
      required String? bucketingKey,
      SplitConfiguration? sdkConfiguration}) {
    return _platform.init(
        apiKey: apiKey,
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        sdkConfiguration: sdkConfiguration);
  }

  @override
  Future<bool> removeAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) {
    return _platform.removeAttribute(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        attributeName: attributeName);
  }

  @override
  Future<bool> setAttribute({
    required String matchingKey,
    required String? bucketingKey,
    required String attributeName,
    required value,
  }) {
    return _platform.setAttribute(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        attributeName: attributeName,
        value: value);
  }

  @override
  Future<bool> setAttributes(
      {required String matchingKey,
      required String? bucketingKey,
      required Map<String, dynamic> attributes}) {
    return _platform.setAttributes(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        attributes: attributes);
  }

  @override
  Future<SplitView?> split(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName}) {
    return _platform.split(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        splitName: splitName);
  }

  @override
  Future<List<String>> splitNames(
      {required String matchingKey, required String? bucketingKey}) {
    return _platform.splitNames(
        matchingKey: matchingKey, bucketingKey: bucketingKey);
  }

  @override
  Future<List<SplitView>> splits(
      {required String matchingKey, required String? bucketingKey}) {
    return _platform.splits(
        matchingKey: matchingKey, bucketingKey: bucketingKey);
  }

  @override
  Future<bool> track(
      {required String matchingKey,
      required String? bucketingKey,
      required String eventType,
      String? trafficType,
      double? value,
      Map<String, dynamic> properties = const {}}) {
    return _platform.track(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        eventType: eventType,
        trafficType: trafficType,
        value: value,
        properties: properties);
  }

  @override
  Future<SplitClient> onReady(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  @override
  Future<SplitClient> onReadyFromCache(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  @override
  Stream<SplitClient> onUpdated(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  @override
  Future<SplitClient> onTimeout(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  @override
  Stream<Impression> impressionsStream() {
    return _platform.impressionsStream();
  }
}
