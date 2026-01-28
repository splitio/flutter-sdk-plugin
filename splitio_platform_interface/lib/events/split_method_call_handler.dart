import 'dart:async';

import 'package:splitio_platform_interface/method_call_handler.dart';

/// Handler for Split SDK events
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

  /// Creates a new instance of the Split event method call handler.
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

  /// Returns Future that is completed when the SDK client is ready.
  Future<void> onReady() {
    return _onEvent(_eventClientReady);
  }

  /// Returns Future that is completed when the SDK client is ready from cache.
  Future<void> onReadyFromCache() {
    return _onEvent(_eventClientReadyFromCache);
  }

  /// Returns Stream that emits when the SDK client is updated.
  Stream<void> onUpdated() {
    return _updateStreamCompleter.stream;
  }

  /// Returns Future that is completed when the SDK client times out.
  Future<void> onTimeout() {
    return _onEvent(_eventClientTimeout);
  }

  /// Cleans up resources.
  void destroy() {
    _updateStreamCompleter.close();
  }

  /// Returns Future that is completed when the specified SDK event occurs.
  Future<void> _onEvent(String sdkEvent) {
    if (_triggeredClientEvents.containsKey(sdkEvent) &&
        _triggeredClientEvents[sdkEvent] == true) {
      return Future.value();
    }

    return (_clientEventCallbacks[sdkEvent])?.future ?? Future.error(Object());
  }
}
