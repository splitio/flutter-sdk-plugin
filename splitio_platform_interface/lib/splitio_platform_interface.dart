import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:splitio_platform_interface/method_channel_platform.dart';
import 'package:splitio_platform_interface/split_configuration.dart';
import 'package:splitio_platform_interface/split_impression.dart';
import 'package:splitio_platform_interface/split_result.dart';
import 'package:splitio_platform_interface/split_view.dart';

abstract class _FactoryPlatform {
  Future<void> getClient(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  Future<void> init({
    required String apiKey,
    required String matchingKey,
    required String? bucketingKey,
    SplitConfiguration? sdkConfiguration,
  }) {
    throw UnimplementedError();
  }

  Future<SplitView?> split(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName}) {
    throw UnimplementedError();
  }

  Future<List<String>> splitNames(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  Future<List<SplitView>> splits(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  Stream<Impression> impressionsStream() {
    throw UnimplementedError();
  }
}

abstract class _ClientPlatform {
  Future<String> getTreatment(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {}}) {
    throw UnimplementedError();
  }

  Future<SplitResult> getTreatmentWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {}}) {
    throw UnimplementedError();
  }

  Future<Map<String, String>> getTreatments(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> splitNames,
      Map<String, dynamic> attributes = const {}}) {
    throw UnimplementedError();
  }

  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> splitNames,
      Map<String, dynamic> attributes = const {}}) {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> getAllAttributes(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  Future<bool> setAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName,
      required dynamic value}) {
    throw UnimplementedError();
  }

  Future<bool> setAttributes(
      {required String matchingKey,
      required String? bucketingKey,
      required Map<String, dynamic> attributes}) {
    throw UnimplementedError();
  }

  Future<dynamic> getAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) {
    throw UnimplementedError();
  }

  Future<bool> removeAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) {
    throw UnimplementedError();
  }

  Future<bool> clearAttributes(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  Future<void> flush(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  Future<void> destroy(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  Future<bool> track(
      {required String matchingKey,
      required String? bucketingKey,
      required String eventType,
      String? trafficType,
      double? value,
      Map<String, dynamic> properties = const {}}) {
    throw UnimplementedError();
  }

  Future<void>? onReady(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  Future<void>? onReadyFromCache(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  Stream<void>? onUpdated(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }

  Future<void>? onTimeout(
      {required String matchingKey, required String? bucketingKey}) {
    throw UnimplementedError();
  }
}

/// The interface that implementations of splitio must implement.
///
/// Platform implementations should extend this class rather than implement it as `splitio`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [SplitioPlatform] methods.
abstract class SplitioPlatform extends PlatformInterface
    with _FactoryPlatform, _ClientPlatform {
  SplitioPlatform() : super(token: _token);

  static SplitioPlatform _instance = MethodChannelPlatform();

  static final Object _token = Object();

  static SplitioPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [SplitioPlatform] when they register themselves.
  static set instance(SplitioPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }
}
