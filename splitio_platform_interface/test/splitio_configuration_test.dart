import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_configuration.dart';
import 'package:splitio_platform_interface/split_sync_config.dart';

void main() {
  test('valuesAreMappedCorrectly', () async {
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
    );

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
  });

  test('noSpecialValuesLeavesMapEmpty', () async {
    final SplitConfiguration config = SplitConfiguration();

    expect(config.configurationMap.isEmpty, true);
  });
}
