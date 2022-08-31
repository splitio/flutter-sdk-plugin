import 'dart:async';

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
  Future<void> handle(String methodName, dynamic methodArguments) async {
    if (_clientEventCallbacks.containsKey(methodName)) {
      if (_matchingKey == methodArguments['matchingKey'] &&
          _bucketingKey == methodArguments['bucketingKey']) {
        var clientEventCallback = _clientEventCallbacks[methodName];
        if (clientEventCallback != null && !clientEventCallback.isCompleted) {
          clientEventCallback.complete(_splitClient);
        }

        if (_triggeredClientEvents.containsKey(methodName)) {
          _triggeredClientEvents[methodName] = true;
        }
      }
    } else if (methodName == _eventClientUpdated &&
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
