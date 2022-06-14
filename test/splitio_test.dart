import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splitio/split_configuration.dart';
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
      Splitio().init('api-key', 'matching-key');
      expect(methodName, 'init');
      expect(methodArguments, {
        'apiKey': 'api-key',
        'matchingKey': 'matching-key',
        'sdkConfiguration': {}
      });
    });

    test('init with bucketing key', () {
      Splitio().init('api-key', 'matching-key', bucketingKey: 'bucketing-key');
      expect(methodName, 'init');
      expect(methodArguments, {
        'apiKey': 'api-key',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'sdkConfiguration': {}
      });
    });

    test('init with config', () {
      Splitio().init('api-key', 'matching-key',
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

  group('manager', () {
    test('get split', () {
      Splitio().split('feature');

      expect(methodName, 'split');
      expect(methodArguments, {'featureName': 'feature'});
    });

    test('get split returns SplitView', () {
      //TODO
    });

    test('get split names', () {
      Splitio().splitNames();

      expect(methodName, 'splitNames');
      expect(methodArguments, null);
    });

    test('get split names returns list of strings', () {
      //TODO
    });
  });
}
