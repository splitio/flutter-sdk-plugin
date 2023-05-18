import 'package:flutter_test/flutter_test.dart';
import 'package:splitio/splitio.dart';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

import 'splitio_platform_stub.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  SplitioPlatformStub _platform = SplitioPlatformStub();
  SplitioPlatform.instance = _platform;

  group('initialization', () {
    test('init with matching key only', () {
      Splitio('api-key', 'matching-key');
      expect(_platform.methodName, 'init');
      expect(_platform.methodArguments, {
        'apiKey': 'api-key',
        'matchingKey': 'matching-key',
        'sdkConfiguration': {}
      });
    });

    test('init with bucketing key', () {
      Splitio('api-key', 'matching-key', bucketingKey: 'bucketing-key');
      expect(_platform.methodName, 'init');
      expect(_platform.methodArguments, {
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
              SplitConfiguration(logLevel: SplitLogLevel.debug, streamingEnabled: false));
      expect(_platform.methodName, 'init');
      expect(_platform.methodArguments, {
        'apiKey': 'api-key',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'sdkConfiguration': {'logLevel': 'debug', 'streamingEnabled': false},
      });
    });
  });

  group('client', () {
    test('get client with no keys', () {
      var splitio = Splitio('api-key', 'matching-key');

      splitio.client();

      expect(_platform.methodName, 'getClient');
      expect(_platform.methodArguments, {'matchingKey': 'matching-key'});
    });

    test('get client with new matching key', () {
      var splitio = Splitio('api-key', 'matching-key');

      splitio.client(matchingKey: 'new-matching-key');

      expect(_platform.methodName, 'getClient');
      expect(_platform.methodArguments, {'matchingKey': 'new-matching-key'});
    });

    test('get client with new matching key and bucketing key', () {
      var splitio = Splitio('api-key', 'matching-key');

      splitio.client(
          matchingKey: 'new-matching-key', bucketingKey: 'bucketing-key');

      expect(_platform.methodName, 'getClient');
      expect(_platform.methodArguments,
          {'matchingKey': 'new-matching-key', 'bucketingKey': 'bucketing-key'});
    });
  });

  group('manager', () {
    test('get split names', () {
      var splitio = Splitio('api-key', 'matching-key');
      splitio.splitNames();

      expect(_platform.methodName, 'splitNames');
    });

    test('get splits', () {
      var splitio = Splitio('api-key', 'matching-key');
      splitio.splits();

      expect(_platform.methodName, 'splits');
    });

    test('get split', () {
      var splitio = Splitio('api-key', 'matching-key');
      splitio.split('my_split');

      expect(_platform.methodName, 'split');
      expect(_platform.methodArguments, {'splitName': 'my_split'});
    });
  });
}
