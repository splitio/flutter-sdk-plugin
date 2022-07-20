import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_configuration.dart';
import 'package:splitio/split_view.dart';

typedef ClientReadinessCallback = void Function(SplitClient splitClient);

class Splitio {
  static const MethodChannel _channel = MethodChannel('splitio');

  final String _apiKey;
  final String _defaultMatchingKey;
  late final String? _defaultBucketingKey;
  late final SplitConfiguration? _splitConfiguration;
  final Map<String, ClientReadinessCallback?> _clientReadyCallbacks = {};
  final Map<String, ClientReadinessCallback?> _clientReadyFromCacheCallbacks =
      {};
  final Map<String, ClientReadinessCallback?> _clientTimeoutCallbacks = {};

  Splitio(this._apiKey, this._defaultMatchingKey,
      {String? bucketingKey, SplitConfiguration? configuration}) {
    _defaultBucketingKey = bucketingKey;
    _splitConfiguration = configuration;

    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<void> init() {
    Map<String, Object?> arguments = {
      'apiKey': _apiKey,
      'matchingKey': _defaultMatchingKey,
      'sdkConfiguration': _splitConfiguration?.configurationMap ?? {},
    };

    if (_defaultBucketingKey != null) {
      arguments.addAll({'bucketingKey': _defaultBucketingKey});
    }
    return _channel.invokeMethod('init', arguments);
  }

  Future<SplitClient> client(
      {String? matchingKey,
      String? bucketingKey,
      ClientReadinessCallback? onReady,
      ClientReadinessCallback? onReadyFromCache,
      ClientReadinessCallback? onTimeout}) async {
    String? key = matchingKey ?? _defaultMatchingKey;

    if (onReady != null) {
      _clientReadyCallbacks[_buildKeyForCallbackMap(key, bucketingKey)] =
          onReady;
    }

    if (onReadyFromCache != null) {
      _clientReadyFromCacheCallbacks[
          _buildKeyForCallbackMap(key, bucketingKey)] = onReadyFromCache;
    }

    if (onTimeout != null) {
      _clientTimeoutCallbacks[_buildKeyForCallbackMap(key, bucketingKey)] =
          onTimeout;
    }

    _channel.invokeMethod(
        'getClient', _buildGetClientArguments(key, bucketingKey));

    return SplitClient(key, bucketingKey);
  }

  Future<List<SplitView>> splits() async {
    List<SplitView> list = [];
    await _channel.invokeMethod('splits').then((value) {});
    return list; //TODO
  }

  Future<SplitView?> split(String featureName) async {
    return _channel
        .invokeMethod('split', {'featureName': featureName}).then((value) {
      return null; //TODO
    });
  }

  Future<List<String>> splitNames() async {
    return _channel.invokeMethod('splitNames').then((value) {
      return []; //TODO
    });
  }

  /// Call handler for calls coming from the native side
  Future<void> _methodCallHandler(MethodCall call) async {
    if (call.method == 'clientReady' ||
        call.method == 'clientReadyFromCache' ||
        call.method == 'clientTimeout') {
      var matchingKey = call.arguments['matchingKey'];
      var bucketingKey = call.arguments['bucketingKey'];
      String key = _buildKeyForCallbackMap(matchingKey, bucketingKey ?? 'null');

      if (call.method == 'clientReady' &&
          _clientReadyCallbacks.containsKey(key)) {
        _clientReadyCallbacks[key]
            ?.call(SplitClient(matchingKey, bucketingKey));

        _clientReadyCallbacks.remove(key);
      } else if (call.method == 'clientReadyFromCache' &&
          _clientReadyFromCacheCallbacks.containsKey(key)) {
        _clientReadyFromCacheCallbacks[key]
            ?.call(SplitClient(matchingKey, bucketingKey));

        _clientReadyFromCacheCallbacks.remove(key);
      } else if (call.method == 'clientTimeout' &&
          _clientTimeoutCallbacks.containsKey(key)) {
        _clientTimeoutCallbacks[key]
            ?.call(SplitClient(matchingKey, bucketingKey));

        _clientTimeoutCallbacks.remove(key);
      }
    }
  }

  String _buildKeyForCallbackMap(String matchingKey, String? bucketingKey) {
    return matchingKey + '_' + (bucketingKey ?? 'null');
  }

  Map<String, Object> _buildGetClientArguments(
      String key, String? bucketingKey) {
    var arguments = {
      'matchingKey': key,
    };

    if (bucketingKey != null) {
      arguments.addAll({'bucketingKey': bucketingKey});
    }

    return arguments;
  }
}
