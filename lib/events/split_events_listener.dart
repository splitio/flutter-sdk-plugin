import 'dart:async';

import 'package:splitio/channel/method_channel_manager.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_method_call_handler.dart';

abstract class SplitEventsListener {
  Future<SplitClient> onReady();

  Future<SplitClient> onReadyFromCache();

  Future<SplitClient> onUpdated();

  Future<SplitClient> onTimeout();
}

class DefaultEventsListener extends SplitEventsListener {
  final MethodChannelManager _methodChannelWrapper;

  late final SplitEventMethodCallHandler _methodCallHandler;

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
  Future<SplitClient> onUpdated() {
    return _methodCallHandler.onUpdated();
  }

  @override
  Future<SplitClient> onTimeout() {
    return _methodCallHandler.onTimeout();
  }
}
