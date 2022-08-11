import 'package:flutter_test/flutter_test.dart';
import 'package:splitio/split_configuration.dart';

void main() {
  test('valuesAreMappedCorrectly', () async {
    final SplitConfiguration config = SplitConfiguration(
        enableDebug: true,
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
        trafficType: 'traffic-type',
        sdkEndpoint: 'sdkEndpoint.split.io',
        eventsEndpoint: 'eventsEndpoint.split.io',
        authServiceEndpoint: 'authServiceEndpoint.split.io',
        streamingServiceEndpoint: 'streamingServiceEndpoint.split.io',
        telemetryServiceEndpoint: 'telemetryServiceEndpoint.split.io');

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
  });

  test('noSpecialValuesLeavesMapEmpty', () async {
    final SplitConfiguration config = SplitConfiguration();

    expect(config.configurationMap.isEmpty, true);
  });
}
