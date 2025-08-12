import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

const String _controlTreatment = 'control';
const SplitResult _controlResult = SplitResult(_controlTreatment, null);
const MethodChannel _methodChannel = MethodChannel('splitio');

class MethodChannelPlatform extends SplitioPlatform {
  MethodChannel get methodChannel => _methodChannel;

  final Map<String, SplitEventMethodCallHandler> _handlers = {};

  final ImpressionsMethodCallHandler _impressionsMethodCallHandler =
      ImpressionsMethodCallHandler();

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
    methodChannel.setMethodCallHandler((call) => handle(call));

    Map<String, Object?> arguments = {
      'apiKey': apiKey,
      'matchingKey': matchingKey,
      'sdkConfiguration': sdkConfiguration?.configurationMap ??
          SplitConfiguration().configurationMap,
      // If sdkConfiguration is null, create a new SplitConfiguration to apply default values
    };

    if (bucketingKey != null) {
      arguments.addAll({'bucketingKey': bucketingKey});
    }

    return methodChannel.invokeMethod('init', arguments);
  }

  @override
  Future<void> getClient(
      {required String matchingKey, required String? bucketingKey}) {
    _handlers.addAll({
      _buildMapKey(matchingKey, bucketingKey):
          SplitEventMethodCallHandler(matchingKey, bucketingKey)
    });

    return methodChannel.invokeMethod(
        'getClient', _buildParameters(matchingKey, bucketingKey));
  }

  @override
  Future<bool> clearAttributes(
      {required String matchingKey, required String? bucketingKey}) async {
    return await methodChannel.invokeMethod(
        'clearAttributes', _buildParameters(matchingKey, bucketingKey));
  }

  @override
  Future<void> destroy(
      {required String matchingKey, required String? bucketingKey}) async {
    var handlerKey = _buildMapKey(matchingKey, bucketingKey);
    _handlers[handlerKey]?.destroy();
    _handlers.remove(handlerKey);

    return await methodChannel.invokeMethod(
        'destroy', _buildParameters(matchingKey, bucketingKey));
  }

  @override
  Future<void> flush(
      {required String matchingKey, required String? bucketingKey}) async {
    return await methodChannel.invokeMethod(
        'flush', _buildParameters(matchingKey, bucketingKey));
  }

  @override
  Future<Map<String, dynamic>> getAllAttributes(
      {required String matchingKey, required String? bucketingKey}) async {
    return (await methodChannel.invokeMapMethod('getAllAttributes',
                _buildParameters(matchingKey, bucketingKey)))
            ?.map((key, value) => MapEntry<String, Object?>(key, value)) ??
        {};
  }

  @override
  Future getAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) {
    return methodChannel.invokeMethod(
        'getAttribute',
        _buildParameters(
            matchingKey, bucketingKey, {'attributeName': attributeName}));
  }

  @override
  Future<String> getTreatment(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) async {
    final args = {
      'splitName': splitName,
      'attributes': attributes,
    };
    if (evaluationOptions.properties.isNotEmpty) {
      args['evaluationOptions'] = evaluationOptions.toJson();
    }
    return await methodChannel.invokeMethod(
            'getTreatment', _buildParameters(matchingKey, bucketingKey, args)) ??
        _controlTreatment;
  }

  @override
  Future<SplitResult> getTreatmentWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) async {
    final args = {
      'splitName': splitName,
      'attributes': attributes,
    };
    if (evaluationOptions.properties.isNotEmpty) {
      args['evaluationOptions'] = evaluationOptions.toJson();
    }
    Map? treatment = (await methodChannel.invokeMapMethod(
            'getTreatmentWithConfig',
            _buildParameters(matchingKey, bucketingKey, args)))
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
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) async {
    final args = {
      'splitName': splitNames,
      'attributes': attributes,
    };
    if (evaluationOptions.properties.isNotEmpty) {
      args['evaluationOptions'] = evaluationOptions.toJson();
    }
    Map? treatments = await methodChannel.invokeMapMethod(
        'getTreatments', _buildParameters(matchingKey, bucketingKey, args));

    return treatments
            ?.map((key, value) => MapEntry<String, String>(key, value)) ??
        {for (var item in splitNames) item: _controlTreatment};
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> splitNames,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) async {
    final args = {
      'splitName': splitNames,
      'attributes': attributes,
    };
    if (evaluationOptions.properties.isNotEmpty) {
      args['evaluationOptions'] = evaluationOptions.toJson();
    }
    Map? treatments = await methodChannel.invokeMapMethod(
        'getTreatmentsWithConfig',
        _buildParameters(matchingKey, bucketingKey, args));

    return treatments?.map((key, value) =>
            MapEntry(key, SplitResult(value['treatment'], value['config']))) ??
        {for (var item in splitNames) item: _controlResult};
  }

  @override
  Future<Map<String, String>> getTreatmentsByFlagSet(
      {required String matchingKey,
      required String? bucketingKey,
      required String flagSet,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) async {
    final args = {
      'flagSet': flagSet,
      'attributes': attributes,
    };
    if (evaluationOptions.properties.isNotEmpty) {
      args['evaluationOptions'] = evaluationOptions.toJson();
    }
    Map? treatments = await methodChannel.invokeMapMethod(
        'getTreatmentsByFlagSet',
        _buildParameters(matchingKey, bucketingKey, args));

    return treatments
            ?.map((key, value) => MapEntry<String, String>(key, value)) ??
        {};
  }

  @override
  Future<Map<String, String>> getTreatmentsByFlagSets(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> flagSets,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) async {
    final args = {
      'flagSets': flagSets,
      'attributes': attributes,
    };
    if (evaluationOptions.properties.isNotEmpty) {
      args['evaluationOptions'] = evaluationOptions.toJson();
    }
    Map? treatments = await methodChannel.invokeMapMethod(
        'getTreatmentsByFlagSets',
        _buildParameters(matchingKey, bucketingKey, args));

    return treatments
            ?.map((key, value) => MapEntry<String, String>(key, value)) ??
        {};
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfigByFlagSet(
      {required String matchingKey,
      required String? bucketingKey,
      required String flagSet,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) async {
    final args = {
      'flagSet': flagSet,
      'attributes': attributes,
    };
    if (evaluationOptions.properties.isNotEmpty) {
      args['evaluationOptions'] = evaluationOptions.toJson();
    }
    Map? treatments = await methodChannel.invokeMapMethod(
        'getTreatmentsWithConfigByFlagSet',
        _buildParameters(matchingKey, bucketingKey, args));

    return treatments?.map((key, value) =>
            MapEntry(key, SplitResult(value['treatment'], value['config']))) ??
        {};
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfigByFlagSets(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> flagSets,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) async {
    final args = {
      'flagSets': flagSets,
      'attributes': attributes,
    };
    if (evaluationOptions.properties.isNotEmpty) {
      args['evaluationOptions'] = evaluationOptions.toJson();
    }
    Map? treatments = await methodChannel.invokeMapMethod(
        'getTreatmentsWithConfigByFlagSets',
        _buildParameters(matchingKey, bucketingKey, args));

    return treatments?.map((key, value) =>
        MapEntry(key, SplitResult(value['treatment'], value['config']))) ??
        {};
  }

  @override
  Future<bool> removeAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) async {
    return await methodChannel.invokeMethod(
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
    var result = await methodChannel.invokeMethod(
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
    var result = await methodChannel.invokeMethod(
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
        await methodChannel.invokeMapMethod('split', {'splitName': splitName});

    if (mapResult == null) {
      return null;
    }

    return SplitView.fromEntry(mapResult);
  }

  @override
  Future<List<String>> splitNames() async {
    List<String> splitNames =
        await methodChannel.invokeListMethod<String>('splitNames') ?? [];

    return splitNames;
  }

  @override
  Future<List<SplitView>> splits() async {
    List<Map> callResult = (await methodChannel
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
      return await methodChannel.invokeMethod('track', parameters) as bool;
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

  @override
  Future<UserConsent> getUserConsent() async {
    String userConsent =
        (await methodChannel.invokeMethod('getUserConsent')) as String;
    if (userConsent == 'granted') {
      return UserConsent.granted;
    } else if (userConsent == 'declined') {
      return UserConsent.declined;
    } else {
      return UserConsent.unknown;
    }
  }

  @override
  Future<void> setUserConsent(bool enabled) async {
    await methodChannel.invokeMethod('setUserConsent', {'value': enabled});
  }

  String _buildMapKey(String matchingKey, String? bucketingKey) {
    return '${matchingKey}_$bucketingKey';
  }
}
