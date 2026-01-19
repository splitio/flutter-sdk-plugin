import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_certificate_pinning_configuration.dart';
import 'package:splitio_platform_interface/split_configuration.dart';
import 'package:splitio_platform_interface/split_fallback_treatments_configuration.dart';
import 'package:splitio_platform_interface/split_result.dart';
import 'package:splitio_platform_interface/split_rollout_cache_configuration.dart';
import 'package:splitio_platform_interface/split_sync_config.dart';

void main() {
  test('values are mapped correctly', () async {
    final SplitConfiguration config = SplitConfiguration(
        eventFlushInterval: 2000,
        eventsPerPush: 300,
        eventsQueueSize: 250,
        featuresRefreshRate: 3000,
        impressionsQueueSize: 150,
        persistentAttributesEnabled: true,
        impressionsRefreshRate: 4000,
        segmentsRefreshRate: 5000,
        streamingEnabled: true,
        telemetryRefreshRate: 6000,
        impressionListener: true,
        trafficType: 'traffic-type',
        sdkEndpoint: 'sdkEndpoint.split.io',
        eventsEndpoint: 'eventsEndpoint.split.io',
        authServiceEndpoint: 'authServiceEndpoint.split.io',
        streamingServiceEndpoint: 'streamingServiceEndpoint.split.io',
        telemetryServiceEndpoint: 'telemetryServiceEndpoint.split.io',
        syncConfig:
            SyncConfig(names: ['one', 'two', 'three'], prefixes: ['pre1']),
        impressionsMode: ImpressionsMode.none,
        syncEnabled: false,
        userConsent: UserConsent.declined,
        encryptionEnabled: true,
        logLevel: SplitLogLevel.debug,
        readyTimeout: 1,
        certificatePinningConfiguration: CertificatePinningConfiguration()
            .addPin('host1', 'pin1')
            .addPin('host2', 'pin3')
            .addPin('host1', 'pin2'),
        rolloutCacheConfiguration:
            RolloutCacheConfiguration(expirationDays: 15, clearOnInit: true),
        fallbackTreatments: FallbackTreatmentsConfiguration(
          global: const SplitResult('custom-treatment', null),
          byFlag: {
            'flag1':
                const SplitResult('custom-treatment-flag1', 'config-flag1'),
            'flag2': const SplitResult('custom-treatment-flag2', null),
          },
        ));

    expect(config.configurationMap['eventFlushInterval'], 2000);
    expect(config.configurationMap['eventsPerPush'], 300);
    expect(config.configurationMap['eventsQueueSize'], 250);
    expect(config.configurationMap['featuresRefreshRate'], 3000);
    expect(config.configurationMap['impressionsQueueSize'], 150);
    expect(config.configurationMap['persistentAttributesEnabled'], true);
    expect(config.configurationMap['impressionsRefreshRate'], 4000);
    expect(config.configurationMap['segmentsRefreshRate'], 5000);
    expect(config.configurationMap['streamingEnabled'], true);
    expect(config.configurationMap['telemetryRefreshRate'], 6000);
    expect(config.configurationMap['trafficType'], 'traffic-type');
    expect(config.configurationMap['sdkEndpoint'], 'sdkEndpoint.split.io');
    expect(
        config.configurationMap['eventsEndpoint'], 'eventsEndpoint.split.io');
    expect(config.configurationMap['authServiceEndpoint'],
        'authServiceEndpoint.split.io');
    expect(config.configurationMap['streamingServiceEndpoint'],
        'streamingServiceEndpoint.split.io');
    expect(config.configurationMap['telemetryServiceEndpoint'],
        'telemetryServiceEndpoint.split.io');
    expect(config.configurationMap['impressionListener'], true);
    expect(config.configurationMap['syncConfig']['syncConfigNames'],
        ['one', 'two', 'three']);
    expect(
        config.configurationMap['syncConfig']['syncConfigPrefixes'], ['pre1']);
    expect(config.configurationMap['impressionsMode'], 'none');
    expect(config.configurationMap['syncEnabled'], false);
    expect(config.configurationMap['userConsent'], 'declined');
    expect(config.configurationMap['encryptionEnabled'], true);
    expect(config.configurationMap['logLevel'], 'debug');
    expect(config.configurationMap['readyTimeout'], 1);
    expect(config.configurationMap['certificatePinningConfiguration']['pins'], {
      'host1': ['pin1', 'pin2'],
      'host2': ['pin3']
    });
    expect(
        config.configurationMap['rolloutCacheConfiguration']['expirationDays'],
        15);
    expect(config.configurationMap['rolloutCacheConfiguration']['clearOnInit'],
        true);
    expect(config.configurationMap['fallbackTreatments']['global'],
        equals({'treatment': 'custom-treatment', 'config': null}));
    expect(
        config.configurationMap['fallbackTreatments']['byFlag'],
        equals({
          'flag1': {
            'treatment': 'custom-treatment-flag1',
            'config': 'config-flag1'
          },
          'flag2': {'treatment': 'custom-treatment-flag2', 'config': null}
        }));
  });

  test('no special values leaves map empty', () async {
    final SplitConfiguration config = SplitConfiguration();

    expect(config.configurationMap.length, 1);
    expect(config.configurationMap['readyTimeout'], 10);
  });

  test('sets values are mapped correctly', () async {
    final SplitConfiguration config = SplitConfiguration(
      syncConfig: SyncConfig.flagSets(['one', 'two']),
    );

    expect(config.configurationMap['syncConfig']['syncConfigNames'], []);
    expect(config.configurationMap['syncConfig']['syncConfigPrefixes'], []);
    expect(config.configurationMap['syncConfig']['syncConfigFlagSets'],
        ['one', 'two']);
  });
}
