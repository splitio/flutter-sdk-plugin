import Foundation
import Split

class SplitClientConfigHelper {

    static private let FEATURES_REFRESH_RATE = "featuresRefreshRate"
    static private let SEGMENTS_REFRESH_RATE = "segmentsRefreshRate"
    static private let IMPRESSIONS_REFRESH_RATE = "impressionsRefreshRate"
    static private let TELEMETRY_REFRESH_RATE = "telemetryRefreshRate"
    static private let EVENTS_QUEUE_SIZE = "eventsQueueSize"
    static private let IMPRESSIONS_QUEUE_SIZE = "impressionsQueueSize"
    static private let EVENT_FLUSH_INTERVAL = "eventFlushInterval"
    static private let EVENTS_PER_PUSH = "eventsPerPush"
    static private let TRAFFIC_TYPE = "trafficType"
    static private let ENABLE_DEBUG = "enableDebug"
    static private let STREAMING_ENABLED = "streamingEnabled"
    static private let PERSISTENT_ATTRIBUTES_ENABLED = "persistentAttributesEnabled"
    static private let SDK_ENDPOINT = "sdkEndpoint"
    static private let EVENTS_ENDPOINT = "eventsEndpoint"
    static private let SSE_AUTH_SERVICE_ENDPOINT = "sseAuthServiceEndpoint"
    static private let STREAMING_SERVICE_ENDPOINT = "streamingServiceEndpoint"
    static private let TELEMETRY_SERVICE_ENDPOINT = "telemetryServiceEndpoint"
    static private let IMPRESSION_LISTENER = "impressionListener"
    static private let SYNC_CONFIG = "syncConfig"
    static private let SYNC_CONFIG_NAMES = "syncConfigNames"
    static private let SYNC_CONFIG_PREFIXES = "syncConfigPrefixes"

    static func fromMap(configurationMap: [String: Any?], impressionListener: SplitImpressionListener?) -> SplitClientConfig {
        let config = SplitClientConfig()

        if configurationMap[FEATURES_REFRESH_RATE] != nil {
            if let featuresRefreshRate = configurationMap[FEATURES_REFRESH_RATE] as? Int {
                config.featuresRefreshRate = featuresRefreshRate
            }
        }

        if configurationMap[SEGMENTS_REFRESH_RATE] != nil {
            if let segmentsRefreshRate = configurationMap[SEGMENTS_REFRESH_RATE] as? Int {
                config.segmentsRefreshRate = segmentsRefreshRate
            }
        }

        if configurationMap[IMPRESSIONS_REFRESH_RATE] != nil {
            if let impressionsRefreshRate = configurationMap[IMPRESSIONS_REFRESH_RATE] as? Int {
                config.impressionRefreshRate = impressionsRefreshRate
            }
        }

        if configurationMap[TELEMETRY_REFRESH_RATE] != nil {
            if let telemetryRefreshRate = configurationMap[TELEMETRY_REFRESH_RATE] as? Int {
                config.telemetryRefreshRate = telemetryRefreshRate
            }
        }

        if configurationMap[EVENTS_QUEUE_SIZE] != nil {
            if let eventsQueueSize = configurationMap[EVENTS_QUEUE_SIZE] as? Int {
                config.eventsQueueSize = Int64(eventsQueueSize)
            }
        }

        if configurationMap[IMPRESSIONS_QUEUE_SIZE] != nil {
            if let impressionsQueueSize = configurationMap[IMPRESSIONS_QUEUE_SIZE] as? Int {
                config.impressionsQueueSize = impressionsQueueSize
            }
        }

        if configurationMap[EVENT_FLUSH_INTERVAL] != nil {
            if let eventFlushInterval = configurationMap[EVENT_FLUSH_INTERVAL] as? Int {
                config.eventsPushRate = eventFlushInterval
            }
        }

        if configurationMap[EVENTS_PER_PUSH] != nil {
            if let eventsPerPush = configurationMap[EVENTS_PER_PUSH] as? Int {
                config.eventsPerPush = eventsPerPush
            }
        }

        if configurationMap[TRAFFIC_TYPE] != nil {
            if let trafficType = configurationMap[TRAFFIC_TYPE] as? String {
                config.trafficType = trafficType
            }
        }

        if configurationMap[ENABLE_DEBUG] != nil {
            if let enableDebug = configurationMap[ENABLE_DEBUG] as? Bool {
                config.isDebugModeEnabled = enableDebug
            }
        }

        if configurationMap[STREAMING_ENABLED] != nil {
            if let streamingEnabled = configurationMap[STREAMING_ENABLED] as? Bool {
                config.streamingEnabled = streamingEnabled
            }
        }

        if configurationMap[PERSISTENT_ATTRIBUTES_ENABLED] != nil {
            if let persistentAttributesEnabled = configurationMap[PERSISTENT_ATTRIBUTES_ENABLED] as? Bool {
                config.persistentAttributesEnabled = persistentAttributesEnabled
            }
        }

        let serviceEndpointsBuilder = ServiceEndpoints.builder()

        if configurationMap[SDK_ENDPOINT] != nil {
            if let sdkEndpoint = configurationMap[SDK_ENDPOINT] as? String {
                serviceEndpointsBuilder.set(sdkEndpoint: sdkEndpoint)
            }
        }

        if configurationMap[EVENTS_ENDPOINT] != nil {
            if let eventsEndpoint = configurationMap[EVENTS_ENDPOINT] as? String {
                serviceEndpointsBuilder.set(eventsEndpoint: eventsEndpoint)
            }
        }

        if configurationMap[SSE_AUTH_SERVICE_ENDPOINT] != nil {
            if let sseAuthServiceEndpoint = configurationMap[SSE_AUTH_SERVICE_ENDPOINT] as? String {
                serviceEndpointsBuilder.set(authServiceEndpoint: sseAuthServiceEndpoint)
            }
        }

        if configurationMap[STREAMING_SERVICE_ENDPOINT] != nil {
            if let streamingServiceEndpoint = configurationMap[STREAMING_SERVICE_ENDPOINT] as? String {
                serviceEndpointsBuilder.set(streamingServiceEndpoint: streamingServiceEndpoint)
            }
        }

        if configurationMap[TELEMETRY_SERVICE_ENDPOINT] != nil {
            if let telemetryServiceEndpoint = configurationMap[TELEMETRY_SERVICE_ENDPOINT] as? String {
                serviceEndpointsBuilder.set(telemetryServiceEndpoint: telemetryServiceEndpoint)
            }
        }

        if let impressionListener = impressionListener {
            config.impressionListener = impressionListener
        }

        if configurationMap[SYNC_CONFIG] != nil {
            if let syncConfig = configurationMap[SYNC_CONFIG] as? [String: [String]] {
                let syncConfigBuilder = SyncConfig.builder()
                if let syncNames = syncConfig[SYNC_CONFIG_NAMES] as? [String] {
                    syncConfigBuilder.addSplitFilter(SplitFilter.byName(syncNames))
                }

                if let syncPrefixes = syncConfig[SYNC_CONFIG_NAMES] as? [String] {
                    syncConfigBuilder.addSplitFilter(SplitFilter.byPrefix(syncPrefixes))
                }

                config.sync = syncConfigBuilder.build()
            }
        }

        config.serviceEndpoints = serviceEndpointsBuilder
            .set(sdkEndpoint: "https://sdk.split-stage.io/api")
            .set(eventsEndpoint: "https://events.split-stage.io/api")
            .set(authServiceEndpoint: "https://auth.split-stage.io/api/v2")
            .set(streamingServiceEndpoint: "https://streaming.split.io/sse")
            .set(telemetryServiceEndpoint: "https://telemetry.split-stage.io/api/v1")
            .build()

        return config
    }

    static func impressionListenerEnabled(configurationMap: [String: Any?]) -> Bool {
        if configurationMap[IMPRESSION_LISTENER] != nil {
            if (configurationMap[IMPRESSION_LISTENER] as? Bool) == true {
                return true
            }
        }

        return false
    }
}
