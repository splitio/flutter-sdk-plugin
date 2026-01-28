import 'package:splitio_platform_interface/split_certificate_pinning_configuration.dart';
import 'package:splitio_platform_interface/split_fallback_treatments_configuration.dart';
import 'package:splitio_platform_interface/split_sync_config.dart';
import 'package:splitio_platform_interface/split_rollout_cache_configuration.dart';

/// Split configuration.
class SplitConfiguration {
  /// The configuration map.
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
  /// [eventsPerPush] Maximum size of the batch to push events. Not supported in Web.
  ///
  /// [trafficType] The default traffic type for events tracked using the track method. If not specified, every track call should specify a traffic type.
  ///
  /// [enableDebug] (Deprecated; use logLevel instead) If true, the SDK will log debug messages to the console.
  ///
  /// [streamingEnabled] Boolean flag to enable the streaming service as default synchronization mechanism when in foreground. In the event of an issue with streaming, the SDK will fallback to the polling mechanism. If false, the SDK will poll for changes as usual without attempting to use streaming.
  ///
  /// [persistentAttributesEnabled] Enables saving attributes on persistent cache which is loaded as part of the SDK_READY_FROM_CACHE flow. All functions that mutate the stored attributes map affect the persistent cache. Not supported in Web.
  ///
  /// [impressionListener] Enables impression listener. If true, generated impressions will be streamed in the impressionsStream() method of Splitio.
  ///
  /// [syncConfig] Use it to filter specific feature flags to be synced and evaluated by the SDK. If not set, all feature flags will be downloaded.
  ///
  /// [impressionsMode] This configuration defines how impressions (decisioning events) are queued. Supported modes are [ImpressionsMode.optimized], [ImpressionsMode.none], and [ImpressionsMode.debug]. In [ImpressionsMode.optimized] mode, only unique impressions are queued and posted to Split; this is the recommended mode for experimentation use cases. In [ImpressionsMode.none] mode, no impression is tracked in Split and only minimum viable data to support usage stats is, so never use this mode if you are experimenting with that instance impressions. Use [ImpressionsMode.none] when you want to optimize for feature flagging only use cases and reduce impressions network and storage load. In [ImpressionsMode.debug] mode, ALL impressions are queued and sent to Split; this is useful for validations. This mode doesn't impact the impression listener which receives all generated impressions locally.
  ///
  /// [syncEnabled] Controls the SDK continuous synchronization flags. When true, a running SDK processes rollout plan updates performed in the Split user interface (default). When false, it fetches all data upon init, which ensures a consistent experience during a user session and optimizes resources when these updates are not consumed by the app.
  ///
  /// [userConsent] User consent status used to control the tracking of events and impressions. Possible values are [UserConsent.granted], [UserConsent.declined], and [UserConsent.unknown].
  ///
  /// [encryptionEnabled] If set to true, the local database contents is encrypted. Defaults to false. Not supported in Web.
  ///
  /// [logLevel] Enables logging according to the level specified. Options are [SplitLogLevel.verbose], [SplitLogLevel.none], [SplitLogLevel.debug], [SplitLogLevel.info], [SplitLogLevel.warning], and [SplitLogLevel.error].
  ///
  /// [readyTimeout] Maximum amount of time in seconds to wait before firing the SDK_READY_TIMED_OUT event. Defaults to 10 seconds.
  ///
  /// [certificatePinningConfiguration] Certificate pinning configuration. Pins need to have the format of a base64 SHA-256 or base64 SHA-1 hashes of the SPKI (ex.: "sha256/7HIpactkIAq2Y49orFOOQKurWxmmSFZhBCoQYcRhJ3Y="). Not supported in Web.
  ///
  /// [rolloutCacheConfiguration] Rollout cache configuration.
  ///
  /// [fallbackTreatments] Fallback treatments configuration.
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
    @Deprecated('Use logLevel instead') bool? enableDebug,
    bool? streamingEnabled,
    bool? persistentAttributesEnabled,
    bool? impressionListener,
    String? sdkEndpoint,
    String? eventsEndpoint,
    String? authServiceEndpoint,
    String? streamingServiceEndpoint,
    String? telemetryServiceEndpoint,
    SyncConfig? syncConfig,
    ImpressionsMode? impressionsMode,
    bool? syncEnabled,
    UserConsent? userConsent,
    bool? encryptionEnabled,
    SplitLogLevel? logLevel,
    int? readyTimeout = 10,
    CertificatePinningConfiguration? certificatePinningConfiguration,
    RolloutCacheConfiguration? rolloutCacheConfiguration,
    FallbackTreatmentsConfiguration? fallbackTreatments,
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
        'syncConfigPrefixes': syncConfig.prefixes.toList(growable: false),
        'syncConfigFlagSets': syncConfig.sets.toList(growable: false)
      };
    }

    if (impressionsMode != null) {
      configurationMap['impressionsMode'] = impressionsMode.name;
    }

    if (syncEnabled != null) {
      configurationMap['syncEnabled'] = syncEnabled;
    }

    if (userConsent != null) {
      configurationMap['userConsent'] = userConsent.name;
    }

    if (encryptionEnabled != null) {
      configurationMap['encryptionEnabled'] = encryptionEnabled;
    }

    if (logLevel != null) {
      configurationMap['logLevel'] = logLevel.name;
    }

    if (readyTimeout != null) {
      configurationMap['readyTimeout'] = readyTimeout;
    }

    if (certificatePinningConfiguration != null &&
        certificatePinningConfiguration.pins.isNotEmpty) {
      configurationMap['certificatePinningConfiguration'] = {
        'pins': certificatePinningConfiguration.pins
      };
    }

    if (rolloutCacheConfiguration != null) {
      configurationMap['rolloutCacheConfiguration'] = {
        'expirationDays': rolloutCacheConfiguration.expirationDays,
        'clearOnInit': rolloutCacheConfiguration.clearOnInit
      };
    }

    if (fallbackTreatments != null) {
      configurationMap['fallbackTreatments'] = {
        'global': fallbackTreatments.global,
        'byFlag': fallbackTreatments.byFlag
      };
    }
  }
}

/// Impressions mode.
enum ImpressionsMode {
  /// Debug impressions mode.
  debug,

  /// Optimized impressions mode.
  optimized,

  /// None impressions mode.
  none,
}

/// User consent.
enum UserConsent {
  /// The user grants consent for tracking events and impressions. The SDK sends them to Split cloud.
  granted,

  /// The user declines consent for tracking events and impressions. The SDK does not send them to Split cloud.
  declined,

  /// The user neither grants nor declines consent for tracking events and impressions. The SDK tracks them in its
  /// internal storage, and eventually either sends them or not if the consent status is updated to 'GRANTED' or
  /// 'DECLINED' respectively. The status can be updated at any time with the `UserConsent.setStatus` factory method.
  unknown,
}

/// Split log level.
enum SplitLogLevel {
  /// Verbose log level.
  verbose,

  /// Debug log level.
  debug,

  /// Info log level.
  info,

  /// Warning log level.
  warning,

  /// Error log level.
  error,

  /// None log level.
  none
}
