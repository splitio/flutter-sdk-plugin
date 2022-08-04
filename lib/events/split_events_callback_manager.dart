import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/events/split_method_call_handler.dart';
import 'package:splitio/split_client.dart';

abstract class SplitEventsListener {
  Future<SplitClient> onReady();

  Future<SplitClient> onReadyFromCache();

  Future<SplitClient> onUpdated();

  Future<SplitClient> onTimeout();
}

class SplitEventsListenerImpl extends SplitEventsListener {
  final MethodChannel _channel;

  final MethodCallHandler _methodCallHandler;

  SplitEventsListenerImpl(this._channel, this._methodCallHandler) {
    _channel.setMethodCallHandler((call) => _methodCallHandler.handle(call));
  }

  @override
  Future<SplitClient> onReady() {
    return _methodCallHandler.onReady();
  }

  @override
  Future<SplitClient> onReadyFromCache() {
    return _methodCallHandler.onReadyFromCache();
  }

  @override
  Future<SplitClient> onUpdated() {
    return _methodCallHandler.onUpdated();
  }

  @override
  Future<SplitClient> onTimeout() {
    return _methodCallHandler.onTimeout();
  }
}
