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
    _methodChannelManager.addNativeCallHandler(mockMethodHandler1);
    _methodChannelManager.addNativeCallHandler(mockMethodHandler2);
    _methodChannelManager.addNativeCallHandler(mockMethodHandler3);

    _methodChannelManager.handle(const MethodCall('test-method'));

    expect(mockMethodHandler1.handledCalls, {'test-method'});
    expect(mockMethodHandler2.handledCalls, {'test-method'});
    expect(mockMethodHandler3.handledCalls, {'test-method'});
  });

  test('invokeMethod calls are delegated to channel', () {
    _methodChannelManager.invokeMethod('any-method');

    expect(_channel.calledMethods, {'invokeMethod'});
  });

  test('invokeMapMethod calls are delegated to channel', () {
    _methodChannelManager.invokeMapMethod('any-method');

    expect(_channel.calledMethods, {'invokeMapMethod'});
  });

  test('invokeListMethod calls are delegated to channel', () {
    _methodChannelManager.invokeListMethod('any-method');

    expect(_channel.calledMethods, {'invokeListMethod'});
  });

  test('removed call handlers do not handle methods', () {
    final MethodCallHandlerStub handler1 = MethodCallHandlerStub();
    final MethodCallHandlerStub handler2 = MethodCallHandlerStub();
    final MethodCallHandlerStub handler3 = MethodCallHandlerStub();
    _methodChannelManager.addNativeCallHandler(handler1);
    _methodChannelManager.addNativeCallHandler(handler2);
    _methodChannelManager.addNativeCallHandler(handler3);

    _methodChannelManager.removeNativeCallHandler(handler2);

    _methodChannelManager.handle(const MethodCall('test-method'));

    expect(handler1.handledCalls, {'test-method'});
    expect(handler2.handledCalls, isEmpty);
    expect(handler3.handledCalls, {'test-method'});
  });
}

class MethodCallHandlerStub extends MethodCallHandler {
  final Set<String> handledCalls = {};

  @override
  Future<void> handle(String methodName, dynamic methodArguments) async {
    handledCalls.add(methodName);
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
