import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/splitio.dart';

void main() {
  const MethodChannel channel = MethodChannel('splitio');

  var methodArguments;
  var methodName;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      methodName = methodCall.method;
      methodArguments = methodCall.arguments;

      if (methodCall.method == 'getTreatment') {
        return "";
      }
    });
  });

  group('client', () {
    test('get client with matching key only', () async {
      Splitio().client('matching-key');

      expect(methodName, 'getClient');
      expect(methodArguments,
          {'matchingKey': 'matching-key', 'waitForReady': false});
    });

    test('get client with bucketing key', () async {
      Splitio().client('matching-key', bucketingKey: 'bucketing-key');

      expect(methodName, 'getClient');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'waitForReady': false
      });
    });

    test('get client waiting for ready', () async {
      Splitio().client('matching-key', waitForReady: true);

      expect(methodName, 'getClient');
      expect(methodArguments,
          {'matchingKey': 'matching-key', 'waitForReady': true});
    });

    test('getTreatment without attributes', () async {
      SplitClient client = SplitClient('matching-key', 'bucketing-key');

      client.getTreatment('treatment');

      expect(methodName, 'getTreatment');
      expect(methodArguments, {'attributes': {}});
    });

    test('getTreatment with attributes', () async {
      SplitClient client = SplitClient('matching-key', 'bucketing-key');

      client.getTreatment('treatment', {'attr1': true});

      expect(methodName, 'getTreatment');
      expect(methodArguments, {
        'attributes': {'attr1': true}
      });
    });

    test('getTreatmentWithConfig without attributes', () async {
      SplitClient client = SplitClient('matching-key', 'bucketing-key');

      client.getTreatmentWithConfig('treatment');

      expect(methodName, 'getTreatmentWithConfig');
      expect(methodArguments, {'attributes': {}});
    });

    test('getTreatmentWithConfig with attributes', () async {
      SplitClient client = SplitClient('matching-key', 'bucketing-key');

      client.getTreatment('treatment', {'attr1': true});

      expect(methodName, 'getTreatmentWithConfig');
      expect(methodArguments, {
        'attributes': {'attr1': true}
      });
    });
  });
}
