import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:web/web.dart' as web;
import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_web/splitio_web.dart';
import 'package:splitio_web/src/js_interop.dart';
import 'package:splitio_platform_interface/split_certificate_pinning_configuration.dart';
import 'package:splitio_platform_interface/split_configuration.dart';
import 'package:splitio_platform_interface/split_evaluation_options.dart';
import 'package:splitio_platform_interface/split_sync_config.dart';
import 'package:splitio_platform_interface/split_result.dart';
import 'package:splitio_platform_interface/split_rollout_cache_configuration.dart';
import 'utils/js_interop_test_utils.dart';

extension on web.Window {
  @JS()
  external JS_BrowserSDKPackage? splitio;
}

void main() {

  SplitioWeb _platform = SplitioWeb();
  final mock = SplitioMock();

  setUp(() {
    (web.window as JSObject)['splitio'] = mock.splitio;

    _platform.init(
        apiKey: 'apiKey',
        matchingKey: 'matching-key',
        bucketingKey: 'bucketing-key');
  });

  group('evaluation', () {
    test('getTreatment', () async {
      final result = await _platform.getTreatment(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitName: 'split');

      expect(result, 'on');
      expect(mock.calls.last.methodName, 'getTreatment');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), ['split', {}, {}]);
    });

    test('getTreatment with attributes', () async {
      final result = await _platform.getTreatment(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitName: 'split',
          attributes: {
            'attrBool': true,
            'attrString': 'value',
            'attrInt': 1,
            'attrDouble': 1.1,
            'attrList': ['value1', 100, false],
            'attrSet': {'value3', 100, true},
            'attrNull': null, // not valid attribute value
            'attrMap': {'value5': true} // not valid attribute value
          });

      expect(result, 'on');
      expect(mock.calls.last.methodName, 'getTreatment');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        'split',
        {
          'attrBool': true,
          'attrString': 'value',
          'attrInt': 1,
          'attrDouble': 1.1,
          'attrList': ['value1', 100, false],
          'attrSet': ['value3', 100, true]
        },
        {}
      ]);

      // assert warnings
      expect(mock.calls[mock.calls.length - 2].methodName, 'warn');
      expect(
          jsAnyToDart(mock.calls[mock.calls.length - 2].methodArguments[0]),
          equals(
              'Invalid attribute value: {value5: true}, for key: attrMap, will be ignored'));
      expect(mock.calls[mock.calls.length - 3].methodName, 'warn');
      expect(
          jsAnyToDart(mock.calls[mock.calls.length - 3].methodArguments[0]),
          equals(
              'Invalid attribute value: null, for key: attrNull, will be ignored'));
    });

    test('getTreatment with evaluation properties', () async {
      final result = await _platform.getTreatment(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitName: 'split',
          evaluationOptions: EvaluationOptions({
            'propBool': true,
            'propString': 'value',
            'propInt': 1,
            'propDouble': 1.1,
            'propList': ['value1', 100, false], // not valid property value
            'propSet': {'value3', 100, true}, // not valid property value
            'propNull': null, // not valid property value
            'propMap': {'value5': true} // not valid property value
          }));

      expect(result, 'on');
      expect(mock.calls.last.methodName, 'getTreatment');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        'split',
        {},
        {
          'properties': {
            'propBool': true,
            'propString': 'value',
            'propInt': 1,
            'propDouble': 1.1,
          }
        }
      ]);

      // assert warnings
      expect(mock.calls[mock.calls.length - 2].methodName, 'warn');
      expect(
          jsAnyToDart(mock.calls[mock.calls.length - 2].methodArguments[0]),
          equals(
              'Invalid property value: {value5: true}, for key: propMap, will be ignored'));
      expect(mock.calls[mock.calls.length - 3].methodName, 'warn');
      expect(
          jsAnyToDart(mock.calls[mock.calls.length - 3].methodArguments[0]),
          equals(
              'Invalid property value: null, for key: propNull, will be ignored'));
      expect(mock.calls[mock.calls.length - 4].methodName, 'warn');
      expect(
          jsAnyToDart(mock.calls[mock.calls.length - 4].methodArguments[0]),
          equals(
              'Invalid property value: {value3, 100, true}, for key: propSet, will be ignored'));
      expect(mock.calls[mock.calls.length - 5].methodName, 'warn');
      expect(
          jsAnyToDart(mock.calls[mock.calls.length - 5].methodArguments[0]),
          equals(
              'Invalid property value: [value1, 100, false], for key: propList, will be ignored'));
    });

    test('getTreatments without attributes', () async {
      final result = await _platform.getTreatments(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitNames: ['split1', 'split2']);

      expect(result, {'split1': 'on', 'split2': 'on'});
      expect(mock.calls.last.methodName, 'getTreatments');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        ['split1', 'split2'],
        {},
        {}
      ]);
    });

    test('getTreatments with attributes and evaluation properties', () async {
      final result = await _platform.getTreatments(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitNames: ['split1', 'split2'],
          attributes: {'attr1': true});

      expect(result, {'split1': 'on', 'split2': 'on'});
      expect(mock.calls.last.methodName, 'getTreatments');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        ['split1', 'split2'],
        {'attr1': true},
        {}
      ]);
    });

    test('getTreatmentWithConfig with attributes', () async {
      final result = await _platform.getTreatmentWithConfig(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitName: 'split1',
          attributes: {'attr1': true});

      expect(result.toString(), SplitResult('on', 'some-config').toString());
      expect(mock.calls.last.methodName, 'getTreatmentWithConfig');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        'split1',
        {'attr1': true},
        {}
      ]);
    });

    test('getTreatmentWithConfig without attributes', () async {
      final result = await _platform.getTreatmentWithConfig(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitName: 'split1');

      expect(result.toString(), SplitResult('on', 'some-config').toString());
      expect(mock.calls.last.methodName, 'getTreatmentWithConfig');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), ['split1', {}, {}]);
    });

    test('getTreatmentsWithConfig without attributes', () async {
      final result = await _platform.getTreatmentsWithConfig(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitNames: ['split1', 'split2']);

      expect(result, predicate<Map<String, SplitResult>>((result) {
        return result.length == 2 &&
            result['split1'].toString() ==
                SplitResult('on', 'some-config').toString() &&
            result['split2'].toString() ==
                SplitResult('on', 'some-config').toString();
      }));
      expect(mock.calls.last.methodName, 'getTreatmentsWithConfig');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        ['split1', 'split2'],
        {},
        {}
      ]);
    });

    test('getTreatmentsWithConfig with attributes', () async {
      final result = await _platform.getTreatmentsWithConfig(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          splitNames: ['split1', 'split2'],
          attributes: {'attr1': true});

      expect(result, predicate<Map<String, SplitResult>>((result) {
        return result.length == 2 &&
            result['split1'].toString() ==
                SplitResult('on', 'some-config').toString() &&
            result['split2'].toString() ==
                SplitResult('on', 'some-config').toString();
      }));
      expect(mock.calls.last.methodName, 'getTreatmentsWithConfig');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        ['split1', 'split2'],
        {'attr1': true},
        {}
      ]);
    });

    test('getTreatmentsByFlagSet without attributes', () async {
      final result = await _platform.getTreatmentsByFlagSet(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          flagSet: 'set_1');

      expect(result, {'split1': 'on', 'split2': 'on'});
      expect(mock.calls.last.methodName, 'getTreatmentsByFlagSet');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), ['set_1', {}, {}]);
    });

    test('getTreatmentsByFlagSet with attributes', () async {
      final result = await _platform.getTreatmentsByFlagSet(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          flagSet: 'set_1',
          attributes: {'attr1': true});

      expect(result, {'split1': 'on', 'split2': 'on'});
      expect(mock.calls.last.methodName, 'getTreatmentsByFlagSet');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        'set_1',
        {'attr1': true},
        {}
      ]);
    });

    test('getTreatmentsByFlagSets without attributes', () async {
      final result = await _platform.getTreatmentsByFlagSets(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          flagSets: ['set_1', 'set_2']);

      expect(result, {'split1': 'on', 'split2': 'on'});
      expect(mock.calls.last.methodName, 'getTreatmentsByFlagSets');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        ['set_1', 'set_2'],
        {},
        {}
      ]);
    });

    test('getTreatmentsByFlagSets with attributes', () async {
      final result = await _platform.getTreatmentsByFlagSets(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          flagSets: ['set_1', 'set_2'],
          attributes: {'attr1': true});

      expect(result, {'split1': 'on', 'split2': 'on'});
      expect(mock.calls.last.methodName, 'getTreatmentsByFlagSets');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        ['set_1', 'set_2'],
        {'attr1': true},
        {}
      ]);
    });

    test('getTreatmentsWithConfigByFlagSet without attributes', () async {
      final result = await _platform.getTreatmentsWithConfigByFlagSet(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          flagSet: 'set_1');

      expect(result, predicate<Map<String, SplitResult>>((result) {
        return result.length == 2 &&
            result['split1'].toString() ==
                SplitResult('on', 'some-config').toString() &&
            result['split2'].toString() ==
                SplitResult('on', 'some-config').toString();
      }));
      expect(mock.calls.last.methodName, 'getTreatmentsWithConfigByFlagSet');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), ['set_1', {}, {}]);
    });

    test('getTreatmentsWithConfigByFlagSet with attributes', () async {
      final result = await _platform.getTreatmentsWithConfigByFlagSet(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          flagSet: 'set_1',
          attributes: {'attr1': true});

      expect(result, predicate<Map<String, SplitResult>>((result) {
        return result.length == 2 &&
            result['split1'].toString() ==
                SplitResult('on', 'some-config').toString() &&
            result['split2'].toString() ==
                SplitResult('on', 'some-config').toString();
      }));
      expect(mock.calls.last.methodName, 'getTreatmentsWithConfigByFlagSet');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        'set_1',
        {'attr1': true},
        {}
      ]);
    });

    test('getTreatmentsWithConfigByFlagSets without attributes', () async {
      final result = await _platform.getTreatmentsWithConfigByFlagSets(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          flagSets: ['set_1', 'set_2']);

      expect(result, predicate<Map<String, SplitResult>>((result) {
        return result.length == 2 &&
            result['split1'].toString() ==
                SplitResult('on', 'some-config').toString() &&
            result['split2'].toString() ==
                SplitResult('on', 'some-config').toString();
      }));
      expect(mock.calls.last.methodName, 'getTreatmentsWithConfigByFlagSets');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        ['set_1', 'set_2'],
        {},
        {}
      ]);
    });

    test('getTreatmentsWithConfigByFlagSets with attributes', () async {
      final result = await _platform.getTreatmentsWithConfigByFlagSets(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          flagSets: ['set_1', 'set_2'],
          attributes: {'attr1': true});

      expect(result, predicate<Map<String, SplitResult>>((result) {
        return result.length == 2 &&
            result['split1'].toString() ==
                SplitResult('on', 'some-config').toString() &&
            result['split2'].toString() ==
                SplitResult('on', 'some-config').toString();
      }));
      expect(mock.calls.last.methodName, 'getTreatmentsWithConfigByFlagSets');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        ['set_1', 'set_2'],
        {'attr1': true},
        {}
      ]);
    });
  });

  group('track', () {
    test('track with traffic type, value & properties', () async {
      final result = await _platform.track(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          eventType: 'my_event',
          trafficType: 'my_traffic_type',
          value: 25.10,
          properties: {
            'propBool': true,
            'propString': 'value',
            'propInt': 1,
            'propDouble': 1.1,
            'propList': ['value1', 100, false], // not valid property value
            'propSet': {'value3', 100, true}, // not valid property value
            'propNull': null, // not valid property value
            'propMap': {'value5': true} // not valid property value
          });

      expect(result, true);
      expect(mock.calls.last.methodName, 'track');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        'my_traffic_type',
        'my_event',
        25.10,
        {
          'propBool': true,
          'propString': 'value',
          'propInt': 1,
          'propDouble': 1.1,
        }
      ]);
    });

    test('track with value, and no traffic type in config', () async {
      final result = await _platform.track(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          eventType: 'my_event',
          value: 25.20);

      expect(result, false); // false because no traffic type is provided
      expect(mock.calls.last.methodName, 'track');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart),
          [null, 'my_event', 25.20, {}]);
    });

    test('track without value, and traffic type in config', () async {
      SplitioWeb _platform = SplitioWeb();
      await _platform.init(
          apiKey: 'api-key',
          matchingKey: 'matching-key',
          bucketingKey: null,
          sdkConfiguration:
              SplitConfiguration(trafficType: 'my_traffic_type_in_config'));

      final result = await _platform.track(
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          eventType: 'my_event');

      expect(result, true);
      expect(mock.calls.last.methodName, 'track');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart),
          ['my_traffic_type_in_config', 'my_event', null, {}]);
    });
  });

  group('initialization', () {
    test('init with matching key only', () async {
      SplitioWeb _platform = SplitioWeb();

      await _platform.init(
          apiKey: 'api-key', matchingKey: 'matching-key', bucketingKey: null);

      expect(mock.calls.last.methodName, 'SplitFactory');
      expect(
          jsAnyToDart(mock.calls.last.methodArguments[0]),
          equals({
            'core': {
              'authorizationKey': 'api-key',
              'key': 'matching-key',
            }
          }));
    });

    test('init with bucketing key', () async {
      SplitioWeb _platform = SplitioWeb();

      await _platform.init(
          apiKey: 'api-key',
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key');

      expect(mock.calls.last.methodName, 'SplitFactory');
      expect(
          jsAnyToDart(mock.calls.last.methodArguments[0]),
          equals({
            'core': {
              'authorizationKey': 'api-key',
              'key': {
                'matchingKey': 'matching-key',
                'bucketingKey': 'bucketing-key',
              },
            }
          }));
    });

    test('init with config: empty config', () async {
      SplitioWeb _platform = SplitioWeb();

      await _platform.init(
          apiKey: 'api-key',
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          sdkConfiguration: SplitConfiguration());

      expect(mock.calls.last.methodName, 'SplitFactory');
      expect(
          jsAnyToDart(mock.calls.last.methodArguments[0]),
          equals({
            'core': {
              'authorizationKey': 'api-key',
              'key': {
                'matchingKey': 'matching-key',
                'bucketingKey': 'bucketing-key',
              },
            },
            'startup': {
              'readyTimeout': 10,
            },
            'scheduler': {},
            'urls': {},
            'sync': {},
            'storage': {'type': 'LOCALSTORAGE'}
          }));
    });

    // @TODO validate full config with pluggable Browser SDK modules
    test('init with config: full config', () async {
      SplitioWeb _platform = SplitioWeb();

      await _platform.init(
          apiKey: 'api-key',
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          sdkConfiguration: SplitConfiguration(
              featuresRefreshRate: 1,
              segmentsRefreshRate: 2,
              impressionsRefreshRate: 3,
              telemetryRefreshRate: 4,
              eventsQueueSize: 5,
              impressionsQueueSize: 6,
              eventFlushInterval: 7,
              eventsPerPush: 8, // unsupported in Web
              trafficType: 'user',
              enableDebug: false, // deprecated, logLevel has precedence
              streamingEnabled: false,
              persistentAttributesEnabled: true, // unsupported in Web
              impressionListener: true,
              sdkEndpoint: 'sdk-endpoint',
              eventsEndpoint: 'events-endpoint',
              authServiceEndpoint: 'auth-service-endpoint',
              streamingServiceEndpoint: 'streaming-service-endpoint',
              telemetryServiceEndpoint: 'telemetry-service-endpoint',
              syncConfig: SyncConfig(
                  names: ['flag_1', 'flag_2'], prefixes: ['prefix_1']),
              impressionsMode: ImpressionsMode.none,
              syncEnabled: true,
              userConsent: UserConsent.granted,
              encryptionEnabled: true, // unsupported in Web
              logLevel: SplitLogLevel.info,
              readyTimeout: 1,
              certificatePinningConfiguration: CertificatePinningConfiguration()
                  .addPin('host', 'pin'), // unsupported in Web
              rolloutCacheConfiguration: RolloutCacheConfiguration(
                expirationDays: 100,
                clearOnInit: true,
              )));

      expect(mock.calls[mock.calls.length - 5].methodName, 'SplitFactory');
      expect(
          jsAnyToDart(mock.calls[mock.calls.length - 5].methodArguments[0]),
          equals({
            'core': {
              'authorizationKey': 'api-key',
              'key': {
                'matchingKey': 'matching-key',
                'bucketingKey': 'bucketing-key',
              },
            },
            'streamingEnabled': false,
            'startup': {
              'readyTimeout': 1,
            },
            'debug': 'INFO',
            'scheduler': {
              'featuresRefreshRate': 1,
              'segmentsRefreshRate': 2,
              'impressionsRefreshRate': 3,
              'telemetryRefreshRate': 4,
              'eventsQueueSize': 5,
              'impressionsQueueSize': 6,
              'eventsPushRate': 7,
            },
            'urls': {
              'sdk': 'sdk-endpoint',
              'events': 'events-endpoint',
              'auth': 'auth-service-endpoint',
              'streaming': 'streaming-service-endpoint',
              'telemetry': 'telemetry-service-endpoint',
            },
            'sync': {
              'impressionsMode': 'NONE',
              'enabled': true,
              'splitFilters': [
                {
                  'type': 'byName',
                  'values': ['flag_1', 'flag_2']
                },
                {
                  'type': 'byPrefix',
                  'values': ['prefix_1']
                }
              ]
            },
            'userConsent': 'GRANTED',
            'storage': {
              'type': 'LOCALSTORAGE',
              'expirationDays': 100,
              'clearOnInit': true
            }
          }));

      expect(mock.calls[mock.calls.length - 4].methodName, 'warn');
      expect(
          jsAnyToDart(mock.calls[mock.calls.length - 4].methodArguments[0]),
          equals(
              'Config certificatePinningConfiguration is not supported by the Web package. This config will be ignored.'));

      expect(mock.calls[mock.calls.length - 3].methodName, 'warn');
      expect(
          jsAnyToDart(mock.calls[mock.calls.length - 3].methodArguments[0]),
          equals(
              'Config encryptionEnabled is not supported by the Web package. This config will be ignored.'));

      expect(mock.calls[mock.calls.length - 2].methodName, 'warn');
      expect(
          jsAnyToDart(mock.calls[mock.calls.length - 2].methodArguments[0]),
          equals(
              'Config eventsPerPush is not supported by the Web package. This config will be ignored.'));

      expect(mock.calls[mock.calls.length - 1].methodName, 'warn');
      expect(
          jsAnyToDart(mock.calls[mock.calls.length - 1].methodArguments[0]),
          equals(
              'Config persistentAttributesEnabled is not supported by the Web package. This config will be ignored.'));
    });

    test('init with config: SyncConfig.flagSets', () async {
      SplitioWeb _platform = SplitioWeb();

      await _platform.init(
          apiKey: 'api-key',
          matchingKey: 'matching-key',
          bucketingKey: 'bucketing-key',
          sdkConfiguration: SplitConfiguration(
              syncConfig: SyncConfig.flagSets(['flag_set_1', 'flag_set_2'])));

      expect(mock.calls.last.methodName, 'SplitFactory');
      expect(
          jsAnyToDart(mock.calls.last.methodArguments[0]),
          equals({
            'core': {
              'authorizationKey': 'api-key',
              'key': {
                'matchingKey': 'matching-key',
                'bucketingKey': 'bucketing-key',
              },
            },
            'startup': {
              'readyTimeout': 10,
            },
            'scheduler': {},
            'urls': {},
            'sync': {
              'splitFilters': [
                {
                  'type': 'bySet',
                  'values': ['flag_set_1', 'flag_set_2']
                }
              ]
            },
            'storage': {'type': 'LOCALSTORAGE'}
          }));
    });
  });

  group('client', () {
    test('get client with no keys', () async {
      await _platform.getClient(
          matchingKey: 'matching-key', bucketingKey: null);

      expect(mock.calls.last.methodName, 'client');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), ['matching-key']);
    });

    test('get client with new matching key', () async {
      await _platform.getClient(
          matchingKey: 'new-matching-key', bucketingKey: null);

      expect(mock.calls.last.methodName, 'client');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), ['new-matching-key']);
    });

    test('get client with new matching key and bucketing key', () async {
      await _platform.getClient(
          matchingKey: 'new-matching-key', bucketingKey: 'bucketing-key');

      expect(mock.calls.last.methodName, 'client');
      expect(mock.calls.last.methodArguments.map(jsAnyToDart), [
        {'matchingKey': 'new-matching-key', 'bucketingKey': 'bucketing-key'}
      ]);
    });
  });
}
