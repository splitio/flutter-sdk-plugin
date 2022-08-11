import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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

      if (methodCall.method == 'splitNames') {
        List<String> emptyList = [];
        return Future.value(emptyList);
      }
    });
  });

  tearDown(() async {
    methodName = null;
    methodArguments = null;
  });

  group('initialization', () {
    test('init with matching key only', () {
      Splitio('api-key', 'matching-key');
      expect(methodName, 'init');
      expect(methodArguments, {
        'apiKey': 'api-key',
        'matchingKey': 'matching-key',
        'sdkConfiguration': {}
      });
    });

    test('init with bucketing key', () {
      Splitio('api-key', 'matching-key', bucketingKey: 'bucketing-key');
      expect(methodName, 'init');
      expect(methodArguments, {
        'apiKey': 'api-key',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'sdkConfiguration': {}
      });
    });

    test('init with config', () {
      Splitio('api-key', 'matching-key',
          bucketingKey: 'bucketing-key',
          configuration:
              SplitConfiguration(enableDebug: true, streamingEnabled: false));
      expect(methodName, 'init');
      expect(methodArguments, {
        'apiKey': 'api-key',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'sdkConfiguration': {'enableDebug': true, 'streamingEnabled': false},
      });
    });
  });

  group('client', () {
    test('get client with no keys', () {
      var splitio = Splitio('api-key', 'matching-key');

      splitio.client();

      expect(methodName, 'getClient');
      expect(methodArguments, {'matchingKey': 'matching-key'});
    });

    test('get client with new matching key', () {
      var splitio = Splitio('api-key', 'matching-key');

      splitio.client(matchingKey: 'new-matching-key');

      expect(methodName, 'getClient');
      expect(methodArguments, {'matchingKey': 'new-matching-key'});
    });

    test('get client with new matching key and bucketing key', () {
      var splitio = Splitio('api-key', 'matching-key');

      splitio.client(
          matchingKey: 'new-matching-key', bucketingKey: 'bucketing-key');

      expect(methodName, 'getClient');
      expect(methodArguments,
          {'matchingKey': 'new-matching-key', 'bucketingKey': 'bucketing-key'});
    });
  });

  group('manager', () {
    test('get split names', () {
      var splitio = Splitio('api-key', 'matching-key');
      splitio.splitNames();

      expect(methodName, 'splitNames');
    });

    test('get splits', () {
      var splitio = Splitio('api-key', 'matching-key');
      splitio.splits();

      expect(methodName, 'splits');
    });

    test('get split', () {
      var splitio = Splitio('api-key', 'matching-key');
      splitio.split('my_split');

      expect(methodName, 'split');
      expect(methodArguments, {'splitName': 'my_split'});
    });
  });
}
