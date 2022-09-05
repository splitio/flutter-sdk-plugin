import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/method_channel_platform.dart';
import 'package:splitio_platform_interface/split_configuration.dart';

void main() {
  const MethodChannel _channel = MethodChannel('splitio');

  String methodName = '';
  dynamic methodArguments;

  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelPlatform _platform = MethodChannelPlatform();

  setUp(() {
    _channel.setMockMethodCallHandler((MethodCall methodCall) async {
      methodName = methodCall.method;
      methodArguments = methodCall.arguments;

      switch (methodCall.method) {
        case 'getTreatment':
          return '';
        case 'getTreatments':
          return {'split1': 'on', 'split2': 'off'};
        case 'getTreatmentsWithConfig':
          return {
            'split1': {'treatment': 'on', 'config': null},
            'split2': {'treatment': 'off', 'config': null}
          };
        case 'track':
          return true;
        case 'getAttribute':
          return true;
        case 'getAllAttributes':
          return {
            'attr_1': true,
            'attr_2': ['list-element'],
            'attr_3': 28.20
          };
        case 'setAttribute':
        case 'setAttributes':
        case 'removeAttribute':
        case 'clearAttributes':
          return true;
      }
    });
  });

  group('evaluation', () {
    test('getTreatment without attributes', () async {
      _platform.getTreatment(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitName: 'split');

      expect(methodName, 'getTreatment');
      expect(methodArguments, {
        'splitName': 'split',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatment with attributes', () async {
      _platform.getTreatment(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitName: 'split',
          attributes: {'attr1': true});

      expect(methodName, 'getTreatment');
      expect(methodArguments, {
        'splitName': 'split',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatments without attributes', () async {
      _platform.getTreatments(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitNames: ['split1', 'split2']);

      expect(methodName, 'getTreatments');
      expect(methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatments with attributes', () async {
      _platform.getTreatments(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitNames: ['split1', 'split2'],
          attributes: {'attr1': true});

      expect(methodName, 'getTreatments');
      expect(methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatmentWithConfig with attributes', () async {
      _platform.getTreatmentWithConfig(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitName: 'split1',
          attributes: {'attr1': true});

      expect(methodName, 'getTreatmentWithConfig');
      expect(methodArguments, {
        'splitName': 'split1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatmentWithConfig without attributes', () async {
      _platform.getTreatmentWithConfig(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitName: 'split1');

      expect(methodName, 'getTreatmentWithConfig');
      expect(methodArguments, {
        'splitName': 'split1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatmentsWithConfig without attributes', () async {
      _platform.getTreatmentsWithConfig(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitNames: ['split1', 'split2']);

      expect(methodName, 'getTreatmentsWithConfig');
      expect(methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatmentsWithConfig with attributes', () async {
      _platform.getTreatmentsWithConfig(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitNames: ['split1', 'split2'],
          attributes: {'attr1': true});

      expect(methodName, 'getTreatmentsWithConfig');
      expect(methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });
  });

  group('track', () {
    test('track with traffic type & value', () async {
      _platform.track(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          eventType: 'my_event',
          trafficType: 'my_traffic_type',
          value: 25.10);
      expect(methodName, 'track');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'eventType': 'my_event',
        'trafficType': 'my_traffic_type',
        'value': 25.10
      });
    });

    test('track with value', () async {
      _platform.track(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          eventType: 'my_event',
          value: 25.10);
      expect(methodName, 'track');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'eventType': 'my_event',
        'value': 25.10
      });
    });

    test('track with traffic type', () async {
      _platform.track(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          eventType: 'my_event',
          trafficType: 'my_traffic_type');
      expect(methodName, 'track');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'eventType': 'my_event',
        'trafficType': 'my_traffic_type',
      });
    });
  });

  group('attributes', () {
    test('get single attribute', () async {
      _platform.getAttribute(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          attributeName: 'attribute-name');
      expect(methodName, 'getAttribute');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributeName': 'attribute-name',
      });
    });

    test('get all attributes', () async {
      _platform.getAllAttributes(
          matchingKey: 'matching-key', bucketingKey: 'bucketing-key');
      expect(methodName, 'getAllAttributes');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
      });
    });

    test('set attribute', () async {
      _platform.setAttribute(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          attributeName: 'my_attr',
          value: 'attr_value');
      expect(methodName, 'setAttribute');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributeName': 'my_attr',
        'value': 'attr_value',
      });
    });

    test('set multiple attributes', () async {
      _platform.setAttributes(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          attributes: {
            'bool_attr': true,
            'number_attr': 25.56,
            'string_attr': 'attr-value',
            'list_attr': ['one', 'two'],
          });
      expect(methodName, 'setAttributes');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {
          'bool_attr': true,
          'number_attr': 25.56,
          'string_attr': 'attr-value',
          'list_attr': ['one', 'two'],
        }
      });
    });

    test('remove attribute', () async {
      _platform.removeAttribute(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          attributeName: 'attr-name');
      expect(methodName, 'removeAttribute');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributeName': 'attr-name',
      });
    });

    test('clear attributes', () async {
      _platform.clearAttributes(
          matchingKey: 'matching-key', bucketingKey: 'bucketing-key');
      expect(methodName, 'clearAttributes');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
      });
    });

    test('flush', () async {
      _platform.flush(
          matchingKey: 'matching-key', bucketingKey: 'bucketing-key');
      expect(methodName, 'flush');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
      });
    });

    test('destroy', () async {
      _platform.destroy(
          matchingKey: 'matching-key', bucketingKey: 'bucketing-key');
      expect(methodName, 'destroy');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
      });
    });
  });

  group('initialization', () {
    test('init with matching key only', () {
      _platform.init(
          apiKey: 'api-key', matchingKey: 'matching-key', bucketingKey: null);

      expect(methodName, 'init');
      expect(methodArguments, {
        'apiKey': 'api-key',
        'matchingKey': 'matching-key',
        'sdkConfiguration': {}
      });
    });

    test('init with bucketing key', () {
      _platform.init(
          apiKey: 'api-key',
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key');
      expect(methodName, 'init');
      expect(methodArguments, {
        'apiKey': 'api-key',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'sdkConfiguration': {}
      });
    });

    test('init with config', () {
      _platform.init(
          apiKey: 'api-key',
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          sdkConfiguration:
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
      _platform.getClient(matchingKey: 'matching-key', bucketingKey: null);

      expect(methodName, 'getClient');
      expect(methodArguments, {'matchingKey': 'matching-key'});
    });

    test('get client with new matching key', () {
      _platform.getClient(matchingKey: 'new-matching-key', bucketingKey: null);

      expect(methodName, 'getClient');
      expect(methodArguments, {'matchingKey': 'new-matching-key'});
    });

    test('get client with new matching key and bucketing key', () {
      _platform.getClient(
          matchingKey: 'new-matching-key', bucketingKey: 'bucketing-key');

      expect(methodName, 'getClient');
      expect(methodArguments,
          {'matchingKey': 'new-matching-key', 'bucketingKey': 'bucketing-key'});
    });
  });

  group('manager', () {
    test('get split names', () {
      _platform.splitNames();

      expect(methodName, 'splitNames');
    });

    test('get splits', () {
      _platform.splits();

      expect(methodName, 'splits');
    });

    test('get split', () {
      _platform.split(splitName: 'my_split');

      expect(methodName, 'split');
      expect(methodArguments, {'splitName': 'my_split'});
    });
  });

  group('events', () {
    test('onReady is returned from events listener', () {
      // TODO
    });

    test('onReadyFromCache is returned from events listener', () {
      // TODO
    });

    test('onTimeout is returned from events listener', () {
      // TODO
    });

    test('onUpdated is returned from events listener', () {
      // TODO
    });
  });
}
