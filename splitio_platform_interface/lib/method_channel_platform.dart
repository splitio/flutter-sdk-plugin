import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:splitio_platform_interface/events/split_method_call_handler.dart';
import 'package:splitio_platform_interface/impressions/impressions_method_call_handler.dart';
import 'package:splitio_platform_interface/method_call_handler.dart';
import 'package:splitio_platform_interface/split_configuration.dart';
import 'package:splitio_platform_interface/split_impression.dart';
import 'package:splitio_platform_interface/split_result.dart';
import 'package:splitio_platform_interface/split_view.dart';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

const String _controlTreatment = 'control';
const SplitResult _controlResult = SplitResult(_controlTreatment, null);

class MethodChannelPlatform extends SplitioPlatform {
  late MethodChannel _methodChannel = const MethodChannel('splitio');

  final Map<String, SplitEventMethodCallHandler> _handlers = {};

  final ImpressionsMethodCallHandler _impressionsMethodCallHandler =
      ImpressionsMethodCallHandler();

  MethodChannelPlatform() {
    _methodChannel.setMethodCallHandler((call) => handle(call));
  }

  @visibleForTesting
  MethodChannelPlatform.withoutHandler();

  @visibleForTesting
  Future<void> handle(MethodCall call) async {
    _impressionsMethodCallHandler.handle(call.method, call.arguments);
    for (MethodCallHandler handler in _handlers.values) {
      handler.handle(call.method, call.arguments);
    }
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
  Future<void> getClient(
      {required String matchingKey, required String? bucketingKey}) {
    _handlers.addAll({
      _buildMapKey(matchingKey, bucketingKey):
          SplitEventMethodCallHandler(matchingKey, bucketingKey)
    });

    return _methodChannel.invokeMethod(
        'getClient', _buildParameters(matchingKey, bucketingKey));
  }

  @override
  Future<bool> clearAttributes(
      {required String matchingKey, required String? bucketingKey}) async {
    return await _methodChannel.invokeMethod(
        'clearAttributes', _buildParameters(matchingKey, bucketingKey));
  }

  @override
  Future<void> destroy(
      {required String matchingKey, required String? bucketingKey}) async {
    var handlerKey = _buildMapKey(matchingKey, bucketingKey);
    _handlers[handlerKey]?.destroy();
    _handlers.remove(handlerKey);

    return await _methodChannel.invokeMethod(
        'destroy', _buildParameters(matchingKey, bucketingKey));
  }

  @override
  Future<void> flush(
      {required String matchingKey, required String? bucketingKey}) async {
    return await _methodChannel.invokeMethod(
        'flush', _buildParameters(matchingKey, bucketingKey));
  }

  @override
  Future<Map<String, dynamic>> getAllAttributes(
      {required String matchingKey, required String? bucketingKey}) async {
    return (await _methodChannel.invokeMapMethod('getAllAttributes',
                _buildParameters(matchingKey, bucketingKey)))
            ?.map((key, value) => MapEntry<String, Object?>(key, value)) ??
        {};
  }

  @override
  Future getAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) {
    return _methodChannel.invokeMethod(
        'getAttribute',
        _buildParameters(
            matchingKey, bucketingKey, {'attributeName': attributeName}));
  }

  @override
  Future<String> getTreatment(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {}}) async {
    return await _methodChannel.invokeMethod(
            'getTreatment',
            _buildParameters(matchingKey, bucketingKey,
                {'splitName': splitName, 'attributes': attributes})) ??
        _controlTreatment;
  }

  @override
  Future<SplitResult> getTreatmentWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {}}) async {
    Map? treatment = (await _methodChannel.invokeMapMethod(
            'getTreatmentWithConfig',
            _buildParameters(matchingKey, bucketingKey,
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
  Future<Map<String, String>> getTreatments(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> splitNames,
      Map<String, dynamic> attributes = const {}}) async {
    Map? treatments = await _methodChannel.invokeMapMethod(
        'getTreatments',
        _buildParameters(matchingKey, bucketingKey,
            {'splitName': splitNames, 'attributes': attributes}));

    return treatments
            ?.map((key, value) => MapEntry<String, String>(key, value)) ??
        {for (var item in splitNames) item: _controlTreatment};
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> splitNames,
      Map<String, dynamic> attributes = const {}}) async {
    Map? treatments = await _methodChannel.invokeMapMethod(
        'getTreatmentsWithConfig',
        _buildParameters(matchingKey, bucketingKey,
            {'splitName': splitNames, 'attributes': attributes}));

    return treatments?.map((key, value) =>
            MapEntry(key, SplitResult(value['treatment'], value['config']))) ??
        {for (var item in splitNames) item: _controlResult};
  }

  @override
  Future<bool> removeAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) async {
    return await _methodChannel.invokeMethod(
        'removeAttribute',
        _buildParameters(
            matchingKey, bucketingKey, {'attributeName': attributeName}));
  }

  @override
  Future<bool> setAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName,
      required value}) async {
    var result = await _methodChannel.invokeMethod(
        'setAttribute',
        _buildParameters(matchingKey, bucketingKey,
            {'attributeName': attributeName, 'value': value}));

    if (result is bool) {
      return result;
    }

    return false;
  }

  @override
  Future<bool> setAttributes(
      {required String matchingKey,
      required String? bucketingKey,
      required Map<String, dynamic> attributes}) async {
    var result = await _methodChannel.invokeMethod(
        'setAttributes',
        _buildParameters(
            matchingKey, bucketingKey, {'attributes': attributes}));

    if (result is bool) {
      return result;
    }

    return false;
  }

  @override
  Future<SplitView?> split({required String splitName}) async {
    Map? mapResult =
        await _methodChannel.invokeMapMethod('split', {'splitName': splitName});

    if (mapResult == null) {
      return null;
    }

    return SplitView.fromEntry(mapResult);
  }

  @override
  Future<List<String>> splitNames() async {
    List<String> splitNames =
        await _methodChannel.invokeListMethod<String>('splitNames') ?? [];

    return splitNames;
  }

  @override
  Future<List<SplitView>> splits() async {
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
      Map<String, dynamic> properties = const {}}) async {
    var parameters =
        _buildParameters(matchingKey, bucketingKey, {'eventType': eventType});

    if (trafficType != null) {
      parameters['trafficType'] = trafficType;
    }

    if (value != null) {
      parameters['value'] = value;
    }

    try {
      return await _methodChannel.invokeMethod('track', parameters) as bool;
    } on Exception catch (_) {
      return false;
    }
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
      result.addAll({'bucketingKey': bucketingKey});
    }

    return result;
  }

  @override
  Future<void>? onReady(
      {required String matchingKey, required String? bucketingKey}) {
    return _handlers[_buildMapKey(matchingKey, bucketingKey)]?.onReady();
  }

  @override
  Future<void>? onReadyFromCache(
      {required String matchingKey, required String? bucketingKey}) {
    return _handlers[_buildMapKey(matchingKey, bucketingKey)]
        ?.onReadyFromCache();
  }

  @override
  Stream<void>? onUpdated(
      {required String matchingKey, required String? bucketingKey}) {
    return _handlers[_buildMapKey(matchingKey, bucketingKey)]?.onUpdated();
  }

  @override
  Future<void>? onTimeout(
      {required String matchingKey, required String? bucketingKey}) {
    return _handlers[_buildMapKey(matchingKey, bucketingKey)]?.onTimeout();
  }

  @override
  Stream<Impression> impressionsStream() {
    return _impressionsMethodCallHandler.stream();
  }

  String _buildMapKey(String matchingKey, String? bucketingKey) {
    return '${matchingKey}_$bucketingKey';
  }
}
