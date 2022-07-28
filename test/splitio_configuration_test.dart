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

    assert(config.configurationMap['eventFlushInterval'] == 2000);
    assert(config.configurationMap['eventsPerPush'] == 300);
    assert(config.configurationMap['eventsQueueSize'] == 250);
    assert(config.configurationMap['featuresRefreshRate'] == 3000);
    assert(config.configurationMap['impressionsQueueSize'] == 150);
    assert(config.configurationMap['persistentAttributesEnabled'] == true);
    assert(config.configurationMap['impressionsRefreshRate'] == 4000);
    assert(config.configurationMap['segmentsRefreshRate'] == 5000);
    assert(config.configurationMap['streamingEnabled'] == true);
    assert(config.configurationMap['telemetryRefreshRate'] == 6000);
    assert(config.configurationMap['trafficType'] == 'traffic-type');
    assert(config.configurationMap['sdkEndpoint'] == 'sdkEndpoint.split.io');
    assert(
        config.configurationMap['eventsEndpoint'] == 'eventsEndpoint.split.io');
    assert(config.configurationMap['authServiceEndpoint'] ==
        'sseAuthServiceEndpoint.split.io');
    assert(config.configurationMap['streamingServiceEndpoint'] ==
        'streamingServiceEndpoint.split.io');
    assert(config.configurationMap['telemetryServiceEndpoint'] ==
        'telemetryServiceEndpoint.split.io');
  });

  test('noSpecialValuesLeavesMapEmpty', () async {
    final SplitConfiguration config = SplitConfiguration();

    assert(config.configurationMap.isEmpty);
  });
}
