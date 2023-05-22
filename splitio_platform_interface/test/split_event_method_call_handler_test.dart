import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/events/split_method_call_handler.dart';

void main() {
  const MethodChannel _channel = MethodChannel('splitio');

  TestWidgetsFlutterBinding.ensureInitialized();

  SplitEventMethodCallHandler splitEventMethodCallHandler =
      SplitEventMethodCallHandler('key', 'bucketing');

  void _simulateMethodInvocation(String methodName,
      {String key = 'key', String bucketingKey = 'bucketing'}) {
    _channel.invokeMethod(
        methodName, {'matchingKey': key, 'bucketingKey': bucketingKey});
  }

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (MethodCall methodCall) {
      splitEventMethodCallHandler.handle(
          methodCall.method, methodCall.arguments);
      return null;
    });
  });

  group('client events', () {
    test('test client ready', () async {
      Future<bool> future =
          splitEventMethodCallHandler.onReady().then((value) => true);
      _simulateMethodInvocation('clientReady');

      expect(future, completion(equals(true)));
    });

    test('test multiple client ready', () async {
      Future<bool> future =
          splitEventMethodCallHandler.onReady().then((value) => true);
      _simulateMethodInvocation('clientReady');

      expect(future, completion(equals(true)));

      _simulateMethodInvocation('clientReady');
      expect(future, completion(equals(true)));
    });

    test('test client ready from cache', () async {
      Future<bool> future =
          splitEventMethodCallHandler.onReadyFromCache().then((value) => true);
      _simulateMethodInvocation('clientReadyFromCache');

      expect(future, completion(equals(true)));
    });

    test('test multiple client ready from cache', () async {
      Future<bool> future =
          splitEventMethodCallHandler.onReady().then((value) => true);
      _simulateMethodInvocation('clientReadyFromCache');

      expect(future, completion(equals(true)));

      _simulateMethodInvocation('clientReadyFromCache');
      expect(future, completion(equals(true)));
    });

    test('test client timeout', () async {
      Future<bool> future =
          splitEventMethodCallHandler.onTimeout().then((value) => true);
      _simulateMethodInvocation('clientTimeout');

      expect(future, completion(equals(true)));
    });

    test('test multiple client timeout', () async {
      Future<bool> future =
          splitEventMethodCallHandler.onReady().then((value) => true);
      _simulateMethodInvocation('clientTimeout');

      expect(future, completion(equals(true)));

      _simulateMethodInvocation('clientTimeout');
      expect(future, completion(equals(true)));
    });

    test('test client updated', () async {
      var count = 0;
      splitEventMethodCallHandler
          .onUpdated()
          .map((event) => ++count)
          .take(3)
          .toList()
          .then((value) => expect(value, [1, 2]));

      _simulateMethodInvocation('clientUpdated');
      _simulateMethodInvocation('clientUpdated');
    });
  });
}
