import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splitio/channel/method_channel_manager.dart';
import 'package:splitio/events/split_events_listener.dart';
import 'package:splitio/events/split_method_call_handler.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_result.dart';

void main() {
  const MethodChannel _channel = MethodChannel('splitio');

  TestWidgetsFlutterBinding.ensureInitialized();

  SplitClientMock splitClientMock = SplitClientMock();
  SplitEventMethodCallHandler splitEventMethodCallHandler =
      SplitEventMethodCallHandler('key', 'bucketing', splitClientMock);
  late final MethodChannelManager _methodChannelWrapper =
      MethodChannelManager(_channel);

  void _simulateMethodInvocation(String methodName,
      {String key = 'key', String bucketingKey = 'bucketing'}) {
    _channel.invokeMethod(
        methodName, {'matchingKey': key, 'bucketingKey': bucketingKey});
  }

  setUp(() {
    _channel.setMockMethodCallHandler((MethodCall methodCall) {
      splitEventMethodCallHandler.handle(methodCall);
    });
  });

  group('client events', () {
    test('test client ready', () async {
      SplitEventsListener eventListener = DefaultEventsListener(
          _methodChannelWrapper, splitEventMethodCallHandler);
      Future<bool> future = eventListener.onReady().then((value) => true);
      _simulateMethodInvocation('clientReady');

      expect(future, completion(equals(true)));
    });

    test('test client ready from cache', () async {
      SplitEventsListener eventListener = DefaultEventsListener(
          _methodChannelWrapper, splitEventMethodCallHandler);
      Future<bool> future =
          eventListener.onReadyFromCache().then((value) => true);
      _simulateMethodInvocation('clientReadyFromCache');

      expect(future, completion(equals(true)));
    });

    test('test client timeout', () async {
      SplitEventsListener eventListener = DefaultEventsListener(
          _methodChannelWrapper, splitEventMethodCallHandler);
      Future<bool> future = eventListener.onTimeout().then((value) => true);
      _simulateMethodInvocation('clientTimeout');

      expect(future, completion(equals(true)));
    });

    test('test client updated', () async {
      SplitEventsListener eventListener = DefaultEventsListener(
          _methodChannelWrapper, splitEventMethodCallHandler);
      var count = 0;
      eventListener
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

class SplitClientMock extends SplitClient {
  Map<String, int> calledMethods = {};

  @override
  Future<bool> clearAttributes() {
    calledMethods.update('clearAttributes', (value) => value + 1,
        ifAbsent: () => 1);
    return Future.value(true);
  }

  @override
  Future<void> destroy() {
    calledMethods.update('destroy', (value) => value + 1, ifAbsent: () => 1);
    return Future.value(null);
  }

  @override
  Future<void> flush() {
    calledMethods.update('flush', (value) => value + 1, ifAbsent: () => 1);
    return Future.value(null);
  }

  @override
  Future getAttribute(String attributeName) {
    calledMethods.update('getAttribute', (value) => value + 1,
        ifAbsent: () => 1);
    return Future.value('value');
  }

  @override
  Future<Map<String, dynamic>> getAttributes() {
    calledMethods.update('getAttributes', (value) => value + 1,
        ifAbsent: () => 1);
    return Future.value({'attr1': 'value1'});
  }

  @override
  Future<String> getTreatment(String splitName,
      [Map<String, dynamic> attributes = const {}]) {
    calledMethods.update('getTreatment', (value) => value + 1,
        ifAbsent: () => 1);
    return Future.value('treatment');
  }

  @override
  Future<SplitResult> getTreatmentWithConfig(String splitName,
      [Map<String, dynamic> attributes = const {}]) {
    calledMethods.update('getTreatmentWithConfig', (value) => value + 1,
        ifAbsent: () => 1);
    return Future.value(const SplitResult('treatment', null));
  }

  @override
  Future<Map<String, String>> getTreatments(List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) {
    calledMethods.update('getTreatments', (value) => value + 1,
        ifAbsent: () => 1);
    return Future.value({'split1': 'treatment'});
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      List<String> splitNames,
      [Map<String, dynamic> attributes = const {}]) {
    calledMethods.update('getTreatmentsWithConfig', (value) => value + 1,
        ifAbsent: () => 1);
    return Future.value({'split1': const SplitResult('treatment', null)});
  }

  @override
  Future<SplitClient> whenReady() {
    calledMethods.update('onReady', (value) => value + 1, ifAbsent: () => 1);
    return Future.value(this);
  }

  @override
  Future<SplitClient> whenReadyFromCache() {
    calledMethods.update('onReadyFromCache', (value) => value + 1,
        ifAbsent: () => 1);
    return Future.value(this);
  }

  @override
  Future<SplitClient> whenTimeout() {
    calledMethods.update('onTimeout', (value) => value + 1, ifAbsent: () => 1);
    return Future.value(this);
  }

  @override
  Stream<SplitClient> whenUpdated() {
    calledMethods.update('onUpdated', (value) => value + 1, ifAbsent: () => 1);
    return Stream.value(this);
  }

  @override
  Future<bool> removeAttribute(String attributeName) {
    calledMethods.update('removeAttribute', (value) => value + 1,
        ifAbsent: () => 1);
    return Future.value(true);
  }

  @override
  Future<bool> setAttribute(String attributeName, value) {
    calledMethods.update('setAttribute', (value) => value + 1,
        ifAbsent: () => 1);
    return Future.value(true);
  }

  @override
  Future<bool> setAttributes(Map<String, dynamic> attributes) {
    calledMethods.update('setAttributes', (value) => value + 1,
        ifAbsent: () => 1);
    return Future.value(true);
  }

  @override
  Future<bool> track(String eventType,
      {String? trafficType,
      double? value,
      Map<String, dynamic> properties = const {}}) {
    calledMethods.update('track', (value) => value + 1, ifAbsent: () => 1);
    return Future.value(true);
  }
}
