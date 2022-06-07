import Foundation
import Split

class SplitClientConfigHelper {

    private let FEATURES_REFRESH_RATE = "featuresRefreshRate";
    private let SEGMENTS_REFRESH_RATE = "segmentsRefreshRate";
    private let IMPRESSIONS_REFRESH_RATE = "impressionsRefreshRate";
    private let TELEMETRY_REFRESH_RATE = "telemetryRefreshRate";
    private let EVENTS_QUEUE_SIZE = "eventsQueueSize";
    private let IMPRESSIONS_QUEUE_SIZE = "impressionsQueueSize";
    private let EVENT_FLUSH_INTERVAL = "eventFlushInterval";
    private let EVENTS_PER_PUSH = "eventsPerPush";
    private let TRAFFIC_TYPE = "trafficType";
    private let CONNECTION_TIME_OUT = "connectionTimeOut";
    private let READ_TIMEOUT = "readTimeout";
    private let DISABLE_LABELS = "disableLabels";
    private let ENABLE_DEBUG = "enableDebug";
    private let PROXY_HOST = "proxyHost";
    private let READY = "ready";
    private let STREAMING_ENABLED = "streamingEnabled";
    private let PERSISTENT_ATTRIBUTES_ENABLED = "persistentAttributesEnabled";
    private let API_ENDPOINT = "apiEndpoint";
    private let EVENTS_ENDPOINT = "eventsEndpoint";
    private let SSE_AUTH_SERVICE_ENDPOINT = "sseAuthServiceEndpoint";
    private let STREAMING_SERVICE_ENDPOINT = "streamingServiceEndpoint";
    private let TELEMETRY_SERVICE_ENDPOINT = "telemetryServiceEndpoint";

    static func fromMap(configurationMap: [String: Any?]) -> SplitClientConfig {
        return SplitClientConfig()
    }
}
