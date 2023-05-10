import 'package:splitio_platform_interface/split_sync_config.dart';

class SplitConfiguration {
  final Map<String, dynamic> configurationMap = {};

  /// Initializes the Split configuration.
  ///
  /// [featuresRefreshRate] the SDK polls Split servers for changes to feature flags at this rate (in seconds).
  ///
  /// [segmentsRefreshRate] The SDK polls Split servers for changes to segments at this rate (in seconds).
  ///
  /// [impressionsRefreshRate] The treatment log captures which customer saw what treatment (on, off, etc.) at what time. This log is periodically flushed back to Split servers. This configuration controls how quickly the cache expires after a write (in seconds).
  ///
  /// [telemetryRefreshRate] The SDK caches diagnostic data that it periodically sends to Split servers. This configuration controls how frequently this data is sent back to Split servers (in seconds).
  ///
  /// [eventsQueueSize] When using .track, the number of events to be kept in memory.
  ///
  /// [impressionsQueueSize] Default queue size for impressions.
  ///
  /// [eventFlushInterval] When using .track, how often the events queue is flushed to Split servers.
  ///
  /// [eventsPerPush] Maximum size of the batch to push events.
  ///
  /// [trafficType] The default traffic type for events tracked using the track method. If not specified, every track call should specify a traffic type.
  ///
  /// [enableDebug] If true, the SDK will log debug messages to the console.
  ///
  /// [streamingEnabled] Boolean flag to enable the streaming service as default synchronization mechanism when in foreground. In the event of an issue with streaming, the SDK will fallback to the polling mechanism. If false, the SDK will poll for changes as usual without attempting to use streaming.
  ///
  /// [persistentAttributesEnabled] Enables saving attributes on persistent cache which is loaded as part of the SDK_READY_FROM_CACHE flow. All functions that mutate the stored attributes map affect the persistent cache.
  ///
  /// [impressionListener] Enables impression listener. If true, generated impressions will be streamed in the impressionsStream() method of Splitio.
  ///
  /// [syncConfig] Use it to filter specific feature flags to be synced and evaluated by the SDK. If not set, all feature flags will be downloaded.
  SplitConfiguration({
    int? featuresRefreshRate,
    int? segmentsRefreshRate,
    int? impressionsRefreshRate,
    int? telemetryRefreshRate,
    int? eventsQueueSize,
    int? impressionsQueueSize,
    int? eventFlushInterval,
    int? eventsPerPush,
    String? trafficType,
    bool? enableDebug,
    bool? streamingEnabled,
    bool? persistentAttributesEnabled,
    bool? impressionListener,
    String? sdkEndpoint,
    String? eventsEndpoint,
    String? authServiceEndpoint,
    String? streamingServiceEndpoint,
    String? telemetryServiceEndpoint,
    SyncConfig? syncConfig,
  }) {
    if (featuresRefreshRate != null) {
      configurationMap['featuresRefreshRate'] = featuresRefreshRate;
    }

    if (segmentsRefreshRate != null) {
      configurationMap['segmentsRefreshRate'] = segmentsRefreshRate;
    }

    if (impressionsRefreshRate != null) {
      configurationMap['impressionsRefreshRate'] = impressionsRefreshRate;
    }

    if (telemetryRefreshRate != null) {
      configurationMap['telemetryRefreshRate'] = telemetryRefreshRate;
    }

    if (eventsQueueSize != null) {
      configurationMap['eventsQueueSize'] = eventsQueueSize;
    }

    if (impressionsQueueSize != null) {
      configurationMap['impressionsQueueSize'] = impressionsQueueSize;
    }

    if (eventFlushInterval != null) {
      configurationMap['eventFlushInterval'] = eventFlushInterval;
    }

    if (eventsPerPush != null) {
      configurationMap['eventsPerPush'] = eventsPerPush;
    }

    if (trafficType != null) {
      configurationMap['trafficType'] = trafficType;
    }

    if (enableDebug != null) {
      configurationMap['enableDebug'] = enableDebug;
    }

    if (streamingEnabled != null) {
      configurationMap['streamingEnabled'] = streamingEnabled;
    }

    if (persistentAttributesEnabled != null) {
      configurationMap['persistentAttributesEnabled'] =
          persistentAttributesEnabled;
    }

    if (sdkEndpoint != null) {
      configurationMap['sdkEndpoint'] = sdkEndpoint;
    }

    if (eventsEndpoint != null) {
      configurationMap['eventsEndpoint'] = eventsEndpoint;
    }

    if (authServiceEndpoint != null) {
      configurationMap['authServiceEndpoint'] = authServiceEndpoint;
    }

    if (streamingServiceEndpoint != null) {
      configurationMap['streamingServiceEndpoint'] = streamingServiceEndpoint;
    }

    if (telemetryServiceEndpoint != null) {
      configurationMap['telemetryServiceEndpoint'] = telemetryServiceEndpoint;
    }

    if (impressionListener != null) {
      configurationMap['impressionListener'] = impressionListener;
    }

    if (syncConfig != null) {
      configurationMap['syncConfig'] = {
        'syncConfigNames': syncConfig.names.toList(growable: false),
        'syncConfigPrefixes': syncConfig.prefixes.toList(growable: false)
      };
    }
  }
}
