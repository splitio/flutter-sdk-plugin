import 'dart:async';

import 'package:splitio/channel/method_channel_manager.dart';
import 'package:splitio/events/split_method_call_handler.dart';
import 'package:splitio/split_client.dart';

abstract class SplitEventsListener {
  Future<SplitClient> onReady();

  Future<SplitClient> onReadyFromCache();

  Stream<SplitClient> onUpdated();

  Future<SplitClient> onTimeout();
}

class DefaultEventsListener implements SplitEventsListener {
  final MethodChannelManager _methodChannelWrapper;

  final SplitEventMethodCallHandler _methodCallHandler;

  DefaultEventsListener(this._methodChannelWrapper, this._methodCallHandler) {
    _methodChannelWrapper.addHandler(_methodCallHandler);
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
  Stream<SplitClient> onUpdated() {
    return _methodCallHandler.onUpdated();
  }

  @override
  Future<SplitClient> onTimeout() {
    return _methodCallHandler.onTimeout();
  }
}
