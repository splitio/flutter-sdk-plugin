import 'dart:async';

import 'package:splitio_platform_interface/method_call_handler.dart';

class SplitEventMethodCallHandler implements MethodCallHandler {
  static const String _eventClientReady = 'clientReady';
  static const String _eventClientReadyFromCache = 'clientReadyFromCache';
  static const String _eventClientTimeout = 'clientTimeout';
  static const String _eventClientUpdated = 'clientUpdated';

  final String _matchingKey;
  final String? _bucketingKey;
  final StreamController<void> _updateStreamCompleter = StreamController();

  final Map<String, Completer<void>> _clientEventCallbacks = {
    _eventClientReady: Completer(),
    _eventClientReadyFromCache: Completer(),
    _eventClientTimeout: Completer(),
  };

  final Map<String, bool> _triggeredClientEvents = {
    _eventClientReady: false,
    _eventClientReadyFromCache: false,
    _eventClientTimeout: false,
  };

  SplitEventMethodCallHandler(this._matchingKey, this._bucketingKey);

  @override
  Future<void> handle(String methodName, dynamic methodArguments) async {
    if (_clientEventCallbacks.containsKey(methodName)) {
      if (_matchingKey == methodArguments['matchingKey'] &&
          _bucketingKey == methodArguments['bucketingKey']) {
        var clientEventCallback = _clientEventCallbacks[methodName];
        if (clientEventCallback != null && !clientEventCallback.isCompleted) {
          clientEventCallback.complete();
        }

        if (_triggeredClientEvents.containsKey(methodName)) {
          _triggeredClientEvents[methodName] = true;
        }
      }
    } else if (methodName == _eventClientUpdated &&
        _updateStreamCompleter.hasListener &&
        !_updateStreamCompleter.isPaused &&
        !_updateStreamCompleter.isClosed) {
      _updateStreamCompleter.add(null);
    }
  }

  Future<void> onReady() {
    return _onEvent(_eventClientReady);
  }

  Future<void> onReadyFromCache() {
    return _onEvent(_eventClientReadyFromCache);
  }

  Stream<void> onUpdated() {
    return _updateStreamCompleter.stream;
  }

  Future<void> onTimeout() {
    return _onEvent(_eventClientTimeout);
  }

  void destroy() {
    _updateStreamCompleter.close();
  }

  Future<void> _onEvent(String sdkEvent) {
    if (_triggeredClientEvents.containsKey(sdkEvent) &&
        _triggeredClientEvents[sdkEvent] == true) {
      return Future.value();
    }

    return (_clientEventCallbacks[sdkEvent])?.future ?? Future.error(Object());
  }
}
