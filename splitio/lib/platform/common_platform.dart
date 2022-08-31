import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_configuration.dart';
import 'package:splitio/split_result.dart';
import 'package:splitio/split_view.dart';

abstract class _FactoryPlatform {
  Future<SplitClient> getClient(
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

  Future<Map<String, String>> getAllAttributes(
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
}

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

class MethodChannelPlatform extends SplitioPlatform {
  final MethodChannel _methodChannel = const MethodChannel('splitio');

  @override
  Future<bool> clearAttributes(
      {required String matchingKey, required String? bucketingKey}) {
    // TODO: implement clearAttributes
    throw UnimplementedError();
  }

  @override
  Future<void> destroy(
      {required String matchingKey, required String? bucketingKey}) {
    // TODO: implement destroy
    throw UnimplementedError();
  }

  @override
  Future<void> flush(
      {required String matchingKey, required String? bucketingKey}) {
    // TODO: implement flush
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> getAllAttributes(
      {required String matchingKey, required String? bucketingKey}) {
    // TODO: implement getAllAttributes
    throw UnimplementedError();
  }

  @override
  Future getAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) {
    // TODO: implement getAttribute
    throw UnimplementedError();
  }

  @override
  Future<SplitClient> getClient(
      {required String matchingKey, required String? bucketingKey}) {
    // TODO: implement getClient
    throw UnimplementedError();
  }

  @override
  Future<String> getTreatment(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {}}) {
    // TODO: implement getTreatment
    throw UnimplementedError();
  }

  @override
  Future<SplitResult> getTreatmentWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {}}) {
    // TODO: implement getTreatmentWithConfig
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> getTreatments(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> splitNames,
      Map<String, dynamic> attributes = const {}}) {
    // TODO: implement getTreatments
    throw UnimplementedError();
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> splitNames,
      Map<String, dynamic> attributes = const {}}) {
    // TODO: implement getTreatmentsWithConfig
    throw UnimplementedError();
  }

  @override
  Future<void> init(
      {required String apiKey,
      required String matchingKey,
      required String? bucketingKey,
      SplitConfiguration? sdkConfiguration}) {
    Map<String, Object?> arguments = {
      'apiKey': apiKey,
      'matchingKey': matchingKey,
      'sdkConfiguration': sdkConfiguration?.configurationMap ?? {},
    };

    if (bucketingKey != null) {
      arguments.addAll({'bucketingKey': bucketingKey});
    }

    return _methodChannel.invokeMethod('init', arguments);
  }

  @override
  Future<bool> removeAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) {
    // TODO: implement removeAttribute
    throw UnimplementedError();
  }

  @override
  Future<bool> setAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName,
      required value}) {
    // TODO: implement setAttribute
    throw UnimplementedError();
  }

  @override
  Future<bool> setAttributes(
      {required String matchingKey,
      required String? bucketingKey,
      required Map<String, dynamic> attributes}) {
    // TODO: implement setAttributes
    throw UnimplementedError();
  }

  @override
  Future<SplitView?> split(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName}) async {
    Map? mapResult =
        await _methodChannel.invokeMapMethod('split', {'splitName': splitName});

    if (mapResult == null) {
      return null;
    }

    return SplitView.fromEntry(mapResult);
  }

  @override
  Future<List<String>> splitNames(
      {required String matchingKey, required String? bucketingKey}) async {
    List<String> splitNames =
        await _methodChannel.invokeListMethod<String>('splitNames') ?? [];

    return splitNames;
  }

  @override
  Future<List<SplitView>> splits(
      {required String matchingKey, required String? bucketingKey}) async {
    List<Map> callResult = (await _methodChannel
            .invokeListMethod<Map<dynamic, dynamic>>('splits') ??
        []);

    List<SplitView> splits = [];
    for (var element in callResult) {
      SplitView? splitView = SplitView.fromEntry(element);
      if (splitView != null) {
        splits.add(splitView);
      }
    }

    return Future.value(splits);
  }

  @override
  Future<bool> track(
      {required String matchingKey,
      required String? bucketingKey,
      required String eventType,
      String? trafficType,
      double? value,
      Map<String, dynamic> properties = const {}}) {
    // TODO: implement track
    throw UnimplementedError();
  }

  Map<String, dynamic> _buildParameters(
      String matchingKey, String? bucketingKey,
      [Map<String, dynamic> parameters = const {}]) {
    Map<String, dynamic> result = {};
    result.addAll(parameters);
    result.addAll(_getKeysMap(matchingKey, bucketingKey));

    return result;
  }

  Map<String, String> _getKeysMap(String matchingKey, String? bucketingKey) {
    Map<String, String> result = {'matchingKey': matchingKey};

    if (bucketingKey != null) {
      result.addAll({'bucketingKey': bucketingKey!});
    }

    return result;
  }
}
