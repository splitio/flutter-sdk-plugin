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
    static private let CONNECTION_TIME_OUT = "connectionTimeOut"
    static private let READ_TIMEOUT = "readTimeout"
    static private let DISABLE_LABELS = "disableLabels"
    static private let ENABLE_DEBUG = "enableDebug"
    static private let PROXY_HOST = "proxyHost"
    static private let READY = "ready"
    static private let STREAMING_ENABLED = "streamingEnabled"
    static private let PERSISTENT_ATTRIBUTES_ENABLED = "persistentAttributesEnabled"
    static private let API_ENDPOINT = "apiEndpoint"
    static private let EVENTS_ENDPOINT = "eventsEndpoint"
    static private let SSE_AUTH_SERVICE_ENDPOINT = "sseAuthServiceEndpoint"
    static private let STREAMING_SERVICE_ENDPOINT = "streamingServiceEndpoint"
    static private let TELEMETRY_SERVICE_ENDPOINT = "telemetryServiceEndpoint"

    static func fromMap(configurationMap: [String: Any?]) -> SplitClientConfig {
        let config = SplitClientConfig()
        
        if (configurationMap[FEATURES_REFRESH_RATE] != nil) {
            if let featuresRefreshRate = configurationMap[FEATURES_REFRESH_RATE] as? Int {
                config.featuresRefreshRate = featuresRefreshRate
            }
        }

        if (configurationMap[SEGMENTS_REFRESH_RATE] != nil) {
            if let segmentsRefreshRate = configurationMap[SEGMENTS_REFRESH_RATE] as? Int {
                config.segmentsRefreshRate = segmentsRefreshRate
            }
        }
        
        if (configurationMap[IMPRESSIONS_REFRESH_RATE] != nil) {
            if let impressionsRefreshRate = configurationMap[IMPRESSIONS_REFRESH_RATE] as? Int {
                config.impressionRefreshRate = impressionsRefreshRate
            }
        }

        if (configurationMap[TELEMETRY_REFRESH_RATE] != nil) {
            if let telemetryRefreshRate = configurationMap[TELEMETRY_REFRESH_RATE] as? Int {
                config.telemetryRefreshRate = telemetryRefreshRate
            }
        }

        if (configurationMap[EVENTS_QUEUE_SIZE] != nil) {
            if let eventsQueueSize = configurationMap[EVENTS_QUEUE_SIZE] as? Int64 {
                config.eventsQueueSize = eventsQueueSize
            }
        }

        if (configurationMap[IMPRESSIONS_QUEUE_SIZE] != nil) {
            if let impressionsQueueSize = configurationMap[IMPRESSIONS_QUEUE_SIZE] as? Int {
                config.impressionsQueueSize = impressionsQueueSize
            }
        }

        if (configurationMap[EVENT_FLUSH_INTERVAL] != nil) {
            if let eventFlushInterval = configurationMap[EVENT_FLUSH_INTERVAL] as? Int {
                config.eventsPushRate = eventFlushInterval
            }
        }

        if (configurationMap[EVENTS_PER_PUSH] != nil) {
            if let eventsPerPush = configurationMap[EVENTS_PER_PUSH] as? Int {
                config.eventsPerPush = eventsPerPush
            }
        }

        if (configurationMap[TRAFFIC_TYPE] != nil) {
            if let trafficType = configurationMap[TRAFFIC_TYPE] as? String {
                config.trafficType = trafficType
            }
        }

        if (configurationMap[CONNECTION_TIME_OUT] != nil) {
            if let connectionTimeout = configurationMap[CONNECTION_TIME_OUT] as? Int {
                config.connectionTimeout = connectionTimeout
            }
        }

        if (configurationMap[READ_TIMEOUT] != nil) {
            if let readTimeout = configurationMap[READ_TIMEOUT] as? Int {
                config.sdkReadyTimeOut = readTimeout
            }
        }

        if (configurationMap[DISABLE_LABELS] != nil) {
            if let disableLabels = configurationMap[DISABLE_LABELS] as? Bool {
                config.isLabelsEnabled = !disableLabels
            }
        }

        if (configurationMap[ENABLE_DEBUG] != nil) {
            if let enableDebug = configurationMap[ENABLE_DEBUG] as? Bool {
                config.isDebugModeEnabled = enableDebug
            }
        }

//        if (configurationMap[PROXY_HOST] != nil) {
//            if let proxyHost = configurationMap[PROXY_HOST] as? String {
//                config.proxyHost = proxyHost
//            }
//        }

//        if (configurationMap[READY] != nil) {
//            if let ready = configurationMap[READY] as? Int {
//                config.sdkReadyTimeOut = ready
//            }
//        }

        if (configurationMap[STREAMING_ENABLED] != nil) {
            if let streamingEnabled = configurationMap[STREAMING_ENABLED] as? Bool {
                config.streamingEnabled = streamingEnabled
            }
        }

        if (configurationMap[PERSISTENT_ATTRIBUTES_ENABLED] != nil) {
            if let persistentAttributesEnabled = configurationMap[PERSISTENT_ATTRIBUTES_ENABLED] as? Bool {
                config.persistentAttributesEnabled = persistentAttributesEnabled
            }
        }

        var serviceEndpoints: ServiceEndpoints.Builder = ServiceEndpoints.builder()
        
        if (configurationMap[API_ENDPOINT] != nil) {
            if let apiEndpoint = configurationMap[API_ENDPOINT] as? String {
                serviceEndpoints = serviceEndpoints.set(sdkEndpoint: apiEndpoint)
            }
        }

        if (configurationMap[EVENTS_ENDPOINT] != nil) {
            if let eventsEndpoint = configurationMap[EVENTS_ENDPOINT] as? String {
                serviceEndpoints = serviceEndpoints.set(eventsEndpoint: eventsEndpoint)
            }
        }

        if (configurationMap[SSE_AUTH_SERVICE_ENDPOINT] != nil) {
            if let authServiceEndpoint = configurationMap[SSE_AUTH_SERVICE_ENDPOINT] as? String {
                serviceEndpoints = serviceEndpoints.set(authServiceEndpoint: authServiceEndpoint)
            }
        }

        if (configurationMap[STREAMING_SERVICE_ENDPOINT] != nil) {
            if let streamingServiceEndpoint = configurationMap[STREAMING_SERVICE_ENDPOINT] as? String {
                serviceEndpoints = serviceEndpoints.set(streamingServiceEndpoint: streamingServiceEndpoint)
            }
        }

        if (configurationMap[TELEMETRY_SERVICE_ENDPOINT] != nil) {
            if let telemetryServiceEndpoint = configurationMap[TELEMETRY_SERVICE_ENDPOINT] as? String {
                serviceEndpoints = serviceEndpoints.set(telemetryServiceEndpoint: telemetryServiceEndpoint)
            }
        }
        
        config.serviceEndpoints = serviceEndpoints.build()
        
        return config
    }
}
