import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splitio/channel/method_channel_manager.dart';
import 'package:splitio/method_call_handler.dart';

void main() {
  late MethodChannelStub _channel;
  late MethodChannelManager _methodChannelManager;

  setUp(() {
    _channel = MethodChannelStub('mock');
    TestWidgetsFlutterBinding.ensureInitialized();
    _methodChannelManager = MethodChannelManager(_channel);
  });

  test('handle calls are delegated to each handler', () {
    var mockMethodHandler1 = MethodCallHandlerStub();
    var mockMethodHandler2 = MethodCallHandlerStub();
    var mockMethodHandler3 = MethodCallHandlerStub();
    _methodChannelManager.addHandler(mockMethodHandler1);
    _methodChannelManager.addHandler(mockMethodHandler2);
    _methodChannelManager.addHandler(mockMethodHandler3);

    _methodChannelManager.handle(const MethodCall('test-method'));

    expect({'test-method'}, mockMethodHandler1.handledCalls);
    expect({'test-method'}, mockMethodHandler2.handledCalls);
    expect({'test-method'}, mockMethodHandler3.handledCalls);
  });

  test('invokeMethod calls are delegated to channel', () {
    _methodChannelManager.invokeMethod('any-method');

    expect({'invokeMethod'}, _channel.calledMethods);
  });

  test('invokeMapMethod calls are delegated to channel', () {
    _methodChannelManager.invokeMapMethod('any-method');

    expect({'invokeMapMethod'}, _channel.calledMethods);
  });

  test('invokeListMethod calls are delegated to channel', () {
    _methodChannelManager.invokeListMethod('any-method');

    expect({'invokeListMethod'}, _channel.calledMethods);
  });
}

class MethodCallHandlerStub extends MethodCallHandler {
  final Set<String> handledCalls = {};

  @override
  Future<void> handle(MethodCall call) async {
    handledCalls.add(call.method);
  }
}

class MethodChannelStub extends MethodChannel {
  MethodChannelStub(String name) : super(name);
  Set<String> calledMethods = {};

  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    calledMethods.add('invokeMethod');
    return Future.value(null);
  }

  @override
  Future<Map<K, V>?> invokeMapMethod<K, V>(String method,
      [dynamic arguments]) async {
    calledMethods.add('invokeMapMethod');
    return Future.value(null);
  }

  @override
  Future<List<T>?> invokeListMethod<T>(String method,
      [dynamic arguments]) async {
    calledMethods.add('invokeListMethod');
    return Future.value(null);
  }
}
