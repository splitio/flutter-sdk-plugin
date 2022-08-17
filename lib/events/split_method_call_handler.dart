import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/events/split_events_listener.dart';
import 'package:splitio/method_call_handler.dart';
import 'package:splitio/split_client.dart';

class SplitEventMethodCallHandler
    implements MethodCallHandler, SplitEventsListener {
  static const String _eventClientReady = 'clientReady';
  static const String _eventClientReadyFromCache = 'clientReadyFromCache';
  static const String _eventClientTimeout = 'clientTimeout';
  static const String _eventClientUpdated = 'clientUpdated';

  final String _matchingKey;
  final String? _bucketingKey;
  final SplitClient _splitClient;
  final StreamController<SplitClient> _updateStreamCompleter =
      StreamController();

  final Map<String, Completer<SplitClient>> _clientEventCallbacks = {
    _eventClientReady: Completer(),
    _eventClientReadyFromCache: Completer(),
    _eventClientTimeout: Completer(),
  };

  final Map<String, bool> _triggeredClientEvents = {
    _eventClientReady: false,
    _eventClientReadyFromCache: false,
    _eventClientTimeout: false,
  };

  SplitEventMethodCallHandler(
      this._matchingKey, this._bucketingKey, this._splitClient);

  @override
  Future<void> handle(MethodCall call) async {
    if (_clientEventCallbacks.containsKey(call.method)) {
      if (_matchingKey == call.arguments['matchingKey'] &&
          _bucketingKey == call.arguments['bucketingKey']) {
        _clientEventCallbacks[call.method]?.complete(_splitClient);

        if (_triggeredClientEvents.containsKey(call.method)) {
          _triggeredClientEvents[call.method] = true;
        }
      }
    } else if (call.method == _eventClientUpdated &&
        _updateStreamCompleter.hasListener &&
        !_updateStreamCompleter.isPaused &&
        !_updateStreamCompleter.isClosed) {
      _updateStreamCompleter.add(_splitClient);
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
  Stream<SplitClient> onUpdated() {
    return _updateStreamCompleter.stream;
  }

  @override
  Future<SplitClient> onTimeout() {
    return _onEvent(_eventClientTimeout);
  }

  @override
  void destroy() {
    _updateStreamCompleter.close();
  }

  Future<SplitClient> _onEvent(String sdkEvent) {
    if (_triggeredClientEvents.containsKey(sdkEvent) &&
        _triggeredClientEvents[sdkEvent] == true) {
      return Future.value(_splitClient);
    }

    return (_clientEventCallbacks[sdkEvent])?.future ?? Future.error(Object());
  }
}
