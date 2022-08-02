import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/split_client.dart';

abstract class SplitEventsCallbackManager {
  Future<SplitClient> onReady(String matchingKey, String? bucketingKey);

  Future<SplitClient> onReadyFromCache(
      String matchingKey, String? bucketingKey);

  Future<SplitClient> onUpdated(String matchingKey, String? bucketingKey);

  Future<SplitClient> onTimeout(String matchingKey, String? bucketingKey);

  void register(String matchingKey, String? bucketingKey);
}

class SplitEventCallbackManagerImpl extends SplitEventsCallbackManager {
  static const MethodChannel _channel = MethodChannel('splitio');

  static const String _eventClientReady = 'clientReady';
  static const String _eventClientReadyFromCache = 'clientReadyFromCache';
  static const String _eventClientTimeout = 'clientTimeout';
  static const String _eventClientUpdated = 'clientUpdated';

  final Map<String, Map<String, Completer<SplitClient>?>>
      _clientEventCallbacks = {
    _eventClientReady: {},
    _eventClientReadyFromCache: {},
    _eventClientTimeout: {},
    _eventClientUpdated: {},
  };

  SplitEventCallbackManagerImpl() {
    _channel.setMethodCallHandler((call) => _methodCallHandler(call));
  }

  @override
  Future<SplitClient> onReady(String matchingKey, String? bucketingKey) {
    return _onEvent(_eventClientReady, matchingKey, bucketingKey);
  }

  @override
  Future<SplitClient> onReadyFromCache(
      String matchingKey, String? bucketingKey) {
    return _onEvent(_eventClientReadyFromCache, matchingKey, bucketingKey);
  }

  @override
  Future<SplitClient> onUpdated(String matchingKey, String? bucketingKey) {
    return _onEvent(_eventClientUpdated, matchingKey, bucketingKey);
  }

  @override
  Future<SplitClient> onTimeout(String matchingKey, String? bucketingKey) {
    return _onEvent(_eventClientTimeout, matchingKey, bucketingKey);
  }

  @override
  void register(String matchingKey, String? bucketingKey) {
    _addCallback(_eventClientReady, matchingKey, bucketingKey, Completer());
    _addCallback(
        _eventClientReadyFromCache, matchingKey, bucketingKey, Completer());
    _addCallback(_eventClientTimeout, matchingKey, bucketingKey, Completer());
    _addCallback(_eventClientUpdated, matchingKey, bucketingKey, Completer());
  }

  void _addCallback(String eventType, String matchingKey, String? bucketingKey,
      Completer<SplitClient> callback) {
    _clientEventCallbacks[eventType]
        ?[_buildKeyForCallbackMap(matchingKey, bucketingKey)] = callback;
  }

  String _buildKeyForCallbackMap(String matchingKey, String? bucketingKey) {
    return matchingKey + '_' + (bucketingKey ?? 'null');
  }

  /// Call handler for calls coming from the native side
  Future<void> _methodCallHandler(MethodCall call) async {
    if (_clientEventCallbacks.containsKey(call.method)) {
      var matchingKey = call.arguments['matchingKey'];
      var bucketingKey = call.arguments['bucketingKey'];
      String key = _buildKeyForCallbackMap(matchingKey, bucketingKey ?? 'null');

      if (_clientEventCallbacks[call.method]?.containsKey(key) == true) {
        _clientEventCallbacks[call.method]?[key]
            ?.complete(SplitClient(matchingKey, bucketingKey, this));
      }
    }
  }

  Future<SplitClient> _onEvent(
      String sdkEvent, String matchingKey, String? bucketingKey) {
    return (_clientEventCallbacks[sdkEvent]
                ?[_buildKeyForCallbackMap(matchingKey, bucketingKey)])
            ?.future ??
        Future.error(Object());
  }
}
