import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:web/web.dart' as web;
import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_web/splitio_web.dart';
import 'package:splitio_web/src/js_interop.dart';
import 'package:splitio_platform_interface/split_certificate_pinning_configuration.dart';
import 'package:splitio_platform_interface/split_configuration.dart';
import 'package:splitio_platform_interface/split_sync_config.dart';
import 'package:splitio_platform_interface/split_rollout_cache_configuration.dart';
import 'utils/js_interop_test_utils.dart';

extension on web.Window {
  @JS()
  external JS_BrowserSDKPackage? splitio;
}

void main() {
  final List<({String methodName, List<dynamic> methodArguments})> calls = [];

  final mockLog = JSObject();
  mockLog['warn'] = (JSAny? arg1) {
    calls.add((methodName: 'warn', methodArguments: [arg1]));
  }.toJS;
  final mockSettings = JSObject();
  mockSettings['log'] = mockLog;

  final mockFactory = JSObject();
  mockFactory['settings'] = mockSettings;

  final mockSplitio = JSObject();
  mockSplitio['SplitFactory'] = (JSAny? arg1) {
    calls.add((methodName: 'SplitFactory', methodArguments: [arg1]));
    return mockFactory;
  }.toJS;

  setUp(() {
    (web.window as JSObject).setProperty('splitio'.toJS, mockSplitio);
  });

  group('initialization', () {
    test('init with matching key only', () async {
      SplitioWeb _platform = SplitioWeb();

      await _platform.init(
          apiKey: 'api-key', matchingKey: 'matching-key', bucketingKey: null);

      expect(calls.last.methodName, 'SplitFactory');
      expect(
          jsObjectToMap(calls.last.methodArguments[0]),
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

      expect(calls.last.methodName, 'SplitFactory');
      expect(
          jsObjectToMap(calls.last.methodArguments[0]),
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

      expect(calls.last.methodName, 'SplitFactory');
      expect(
          jsObjectToMap(calls.last.methodArguments[0]),
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

      expect(calls[calls.length - 5].methodName, 'SplitFactory');
      expect(
          jsObjectToMap(calls[calls.length - 5].methodArguments[0]),
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

      expect(calls[calls.length - 4].methodName, 'warn');
      expect(
          jsAnyToDart(calls[calls.length - 4].methodArguments[0]),
          equals(
              'Config certificatePinningConfiguration is not supported by the Web package. This config will be ignored.'));

      expect(calls[calls.length - 3].methodName, 'warn');
      expect(
          jsAnyToDart(calls[calls.length - 3].methodArguments[0]),
          equals(
              'Config encryptionEnabled is not supported by the Web package. This config will be ignored.'));

      expect(calls[calls.length - 2].methodName, 'warn');
      expect(
          jsAnyToDart(calls[calls.length - 2].methodArguments[0]),
          equals(
              'Config eventsPerPush is not supported by the Web package. This config will be ignored.'));

      expect(calls[calls.length - 1].methodName, 'warn');
      expect(
          jsAnyToDart(calls[calls.length - 1].methodArguments[0]),
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

      expect(calls.last.methodName, 'SplitFactory');
      expect(
          jsObjectToMap(calls.last.methodArguments[0]),
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
}
