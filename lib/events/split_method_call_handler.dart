import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/events/split_events_listener.dart';
import 'package:splitio/split_client.dart';

abstract class MethodCallHandler extends SplitEventsListener {
  Future<void> handle(MethodCall call);
}

class SplitEventMethodCallHandler extends MethodCallHandler {
  static const String _eventClientReady = 'clientReady';
  static const String _eventClientReadyFromCache = 'clientReadyFromCache';
  static const String _eventClientTimeout = 'clientTimeout';
  static const String _eventClientUpdated = 'clientUpdated';

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

  final Map<String, Map<String, bool>> _triggeredClientEvents = {
    _eventClientReady: {},
    _eventClientReadyFromCache: {},
    _eventClientTimeout: {},
  };

  SplitEventMethodCallHandler(
      this._matchingKey, this._bucketingKey, this._splitClient) {
    _clientEventCallbacks.forEach((key, value) {
      _clientEventCallbacks[key]
          ?[_buildKeyForCallbackMap(_matchingKey, _bucketingKey)] = Completer();
    });

    _triggeredClientEvents.forEach((key, value) {
      _triggeredClientEvents[key]
          ?[_buildKeyForCallbackMap(_matchingKey, _bucketingKey)] = false;
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

        if (_triggeredClientEvents[call.method]?.containsKey(key) == true) {
          _triggeredClientEvents[call.method]?[key] = true;
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
    if (_triggeredClientEvents.containsKey(sdkEvent) &&
        _triggeredClientEvents[sdkEvent]
                ?[_buildKeyForCallbackMap(_matchingKey, _bucketingKey)] ==
            true) {
      return Future.value(_splitClient);
    }

    return (_clientEventCallbacks[sdkEvent]
                ?[_buildKeyForCallbackMap(_matchingKey, _bucketingKey)])
            ?.future ??
        Future.error(Object());
  }

  String _buildKeyForCallbackMap(String matchingKey, String? bucketingKey) {
    return matchingKey + '_' + (bucketingKey ?? 'null');
  }
}
