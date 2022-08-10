import 'package:flutter/services.dart';
import 'package:splitio/method_call_handler.dart';

class MethodChannelWrapper {
  final MethodChannel _channel;

  final Set<MethodCallHandler> _handlers = {};

  void addHandler(MethodCallHandler handler) {
    _handlers.add(handler);
  }

  MethodChannelWrapper(this._channel) {
    _channel.setMethodCallHandler((call) => handle(call));
  }

  Future<void> handle(MethodCall call) async {
    for (MethodCallHandler handler in _handlers) {
      handler.handle(call);
    }
  }

  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    return _channel.invokeMethod(method, arguments);
  }

  Future<Map<K, V>?> invokeMapMethod<K, V>(String method, [dynamic arguments]) {
    return _channel.invokeMapMethod(method, arguments);
  }

  Future<List<T>?> invokeListMethod<T>(String method, [dynamic arguments]) {
    return _channel.invokeListMethod(method, arguments);
  }
}
