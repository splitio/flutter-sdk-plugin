import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/events/split_events_callback_manager.dart';
import 'package:splitio/split_client.dart';

abstract class MethodCallHandler extends SplitEventsListener {
  Future<void> handle(MethodCall call);
}

class SplitEventMethodCallHandler extends MethodCallHandler {
  static const String _eventClientReady = 'clientReady';
  static const String _eventClientReadyFromCache = 'clientReadyFromCache';
  static const String _eventClientTimeout = 'clientTimeout';
  static const String _eventClientUpdated = 'clientUpdated';

  bool _readyFromCacheTriggered = false;

  final String _matchingKey;
  final String? _bucketingKey;
  final SplitClient _splitClient;

  final Map<String, Map<String, Completer<SplitClient>?>>
      _clientEventCallbacks = {
    _eventClientReady: {},
    _eventClientReadyFromCache: {},
    _eventClientTimeout: {},
    _eventClientUpdated: {},
  };

  SplitEventMethodCallHandler(
      this._matchingKey, this._bucketingKey, this._splitClient) {
    _clientEventCallbacks.forEach((key, value) {
      _addCallback(key, Completer());
    });
  }

  @override
  Future<void> handle(MethodCall call) async {
    if (_clientEventCallbacks.containsKey(call.method)) {
      var matchingKey = call.arguments['matchingKey'];
      var bucketingKey = call.arguments['bucketingKey'];
      String key = _buildKeyForCallbackMap(matchingKey, bucketingKey ?? 'null');

      if (_clientEventCallbacks[call.method]?.containsKey(key) == true) {
        _clientEventCallbacks[call.method]?[key]?.complete(_splitClient);

        if (call.method == _eventClientReadyFromCache) {
          _readyFromCacheTriggered = true;
        }
      }
    }
  }

  @override
  Future<SplitClient> onReady() {
    return _onEvent(_eventClientReady);
  }

  @override
  Future<SplitClient> onReadyFromCache() {
    return _onEvent(_eventClientReadyFromCache);
  }

  @override
  Future<SplitClient> onUpdated() {
    return _onEvent(_eventClientUpdated);
  }

  @override
  Future<SplitClient> onTimeout() {
    return _onEvent(_eventClientTimeout);
  }

  Future<SplitClient> _onEvent(String sdkEvent) {
    if (sdkEvent == _eventClientReadyFromCache && _readyFromCacheTriggered) {
      return Future.value(_splitClient);
    }

    return (_clientEventCallbacks[sdkEvent]
                ?[_buildKeyForCallbackMap(_matchingKey, _bucketingKey)])
            ?.future ??
        Future.error(Object());
  }

  void _addCallback(String eventType, Completer<SplitClient> callback) {
    _clientEventCallbacks[eventType]
        ?[_buildKeyForCallbackMap(_matchingKey, _bucketingKey)] = callback;
  }

  String _buildKeyForCallbackMap(String matchingKey, String? bucketingKey) {
    return matchingKey + '_' + (bucketingKey ?? 'null');
  }
}
