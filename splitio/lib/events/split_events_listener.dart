import 'dart:async';

import 'package:splitio/channel/method_channel_manager.dart';
import 'package:splitio/events/split_method_call_handler.dart';
import 'package:splitio/split_client.dart';

abstract class SplitEventsListener {
  Future<SplitClient> onReady();

  Future<SplitClient> onReadyFromCache();

  Stream<SplitClient> onUpdated();

  Future<SplitClient> onTimeout();

  void destroy();
}

class DefaultEventsListener implements SplitEventsListener {
  final MethodChannelManager _methodChannelManager;

  final SplitEventMethodCallHandler _methodCallHandler;

  DefaultEventsListener(this._methodChannelManager, this._methodCallHandler) {
    _methodChannelManager.addNativeCallHandler(_methodCallHandler);
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

  @override
  void destroy() {
    _methodCallHandler.destroy();
    _methodChannelManager.removeNativeCallHandler(_methodCallHandler);
  }
}
