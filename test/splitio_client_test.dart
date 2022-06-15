import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splitio/split_client.dart';

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
