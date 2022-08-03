package io.split.splitio;

import androidx.annotation.Nullable;

import java.util.Map;

import io.split.android.client.ServiceEndpoints;
import io.split.android.client.SplitClientConfig;

class SplitClientConfigHelper {

    private static final String FEATURES_REFRESH_RATE = "featuresRefreshRate";
    private static final String SEGMENTS_REFRESH_RATE = "segmentsRefreshRate";
    private static final String IMPRESSIONS_REFRESH_RATE = "impressionsRefreshRate";
    private static final String TELEMETRY_REFRESH_RATE = "telemetryRefreshRate";
    private static final String EVENTS_QUEUE_SIZE = "eventsQueueSize";
    private static final String IMPRESSIONS_QUEUE_SIZE = "impressionsQueueSize";
    private static final String EVENT_FLUSH_INTERVAL = "eventFlushInterval";
    private static final String EVENTS_PER_PUSH = "eventsPerPush";
    private static final String TRAFFIC_TYPE = "trafficType";
    private static final String ENABLE_DEBUG = "enableDebug";
    private static final String STREAMING_ENABLED = "streamingEnabled";
    private static final String PERSISTENT_ATTRIBUTES_ENABLED = "persistentAttributesEnabled";
    private static final String SDK_ENDPOINT = "sdkEndpoint";
    private static final String EVENTS_ENDPOINT = "eventsEndpoint";
    private static final String SSE_AUTH_SERVICE_ENDPOINT = "authServiceEndpoint";
    private static final String STREAMING_SERVICE_ENDPOINT = "streamingServiceEndpoint";
    private static final String TELEMETRY_SERVICE_ENDPOINT = "telemetryServiceEndpoint";

    /**
     * Creates a {@link SplitClientConfig} object from a map.
     *
     * @param configurationMap Map of config values.
     * @return {@link SplitClientConfig} object.
     */
    static SplitClientConfig fromMap(Map<String, Object> configurationMap) {
        SplitClientConfig.Builder builder = SplitClientConfig.builder();
        ServiceEndpoints.Builder serviceEndpoints = ServiceEndpoints.builder();

        Integer featuresRefreshRate = getInteger(configurationMap, FEATURES_REFRESH_RATE);
        if (featuresRefreshRate != null) {
            builder.featuresRefreshRate(featuresRefreshRate);
        }

        Integer segmentsRefreshRate = getInteger(configurationMap, SEGMENTS_REFRESH_RATE);
        if (segmentsRefreshRate != null) {
            builder.segmentsRefreshRate(segmentsRefreshRate);
        }

        Integer impressionsRefreshRate = getInteger(configurationMap, IMPRESSIONS_REFRESH_RATE);
        if (impressionsRefreshRate != null) {
            builder.impressionsRefreshRate(impressionsRefreshRate);
        }

        Integer telemetryRefreshRate = getInteger(configurationMap, TELEMETRY_REFRESH_RATE);
        if (telemetryRefreshRate != null) {
            builder.telemetryRefreshRate(telemetryRefreshRate);
        }

        Integer eventsQueueSize = getInteger(configurationMap, EVENTS_QUEUE_SIZE);
        if (eventsQueueSize != null) {
            builder.eventsQueueSize(eventsQueueSize);
        }

        Integer impressionsQueueSize = getInteger(configurationMap, IMPRESSIONS_QUEUE_SIZE);
        if (impressionsQueueSize != null) {
            builder.impressionsQueueSize(impressionsQueueSize);
        }

        Integer eventFlushInterval = getInteger(configurationMap, EVENT_FLUSH_INTERVAL);
        if (eventFlushInterval != null) {
            builder.eventFlushInterval(eventFlushInterval);
        }

        Integer eventsPerPush = getInteger(configurationMap, EVENTS_PER_PUSH);
        if (eventsPerPush != null) {
            builder.eventsPerPush(eventsPerPush);
        }

        String trafficType = getString(configurationMap, TRAFFIC_TYPE);
        if (trafficType != null) {
            builder.trafficType(trafficType);
        }

        Boolean enableDebug = getBoolean(configurationMap, ENABLE_DEBUG);
        if (enableDebug != null && enableDebug) {
            builder.enableDebug();
        }

        Boolean streamingEnabled = getBoolean(configurationMap, STREAMING_ENABLED);
        if (streamingEnabled != null) {
            builder.streamingEnabled(streamingEnabled);
        }

        Boolean persistentAttributesEnabled = getBoolean(configurationMap, PERSISTENT_ATTRIBUTES_ENABLED);
        if (persistentAttributesEnabled != null) {
            builder.persistentAttributesEnabled(persistentAttributesEnabled);
        }

        ServiceEndpoints.Builder serviceEndpointsBuilder = ServiceEndpoints
                .builder();

        String apiEndpoint = getString(configurationMap, SDK_ENDPOINT);
        if (apiEndpoint != null) {
            serviceEndpointsBuilder.apiEndpoint(apiEndpoint);
        }

        String eventsEndpoint = getString(configurationMap, EVENTS_ENDPOINT);
        if (eventsEndpoint != null) {
            serviceEndpointsBuilder.eventsEndpoint(eventsEndpoint);
        }

        String sseAuthServiceEndpoint = getString(configurationMap, SSE_AUTH_SERVICE_ENDPOINT);
        if (sseAuthServiceEndpoint != null) {
            serviceEndpointsBuilder.sseAuthServiceEndpoint(sseAuthServiceEndpoint);
        }

        String streamingServiceEndpoint = getString(configurationMap, STREAMING_SERVICE_ENDPOINT);
        if (streamingServiceEndpoint != null) {
            serviceEndpointsBuilder.streamingServiceEndpoint(streamingServiceEndpoint);
        }

        String telemetryServiceEndpoint = getString(configurationMap, TELEMETRY_SERVICE_ENDPOINT);
        if (telemetryServiceEndpoint != null) {
            serviceEndpointsBuilder.telemetryServiceEndpoint(telemetryServiceEndpoint);
        }

        return builder.serviceEndpoints(serviceEndpointsBuilder.build()).build();
    }

    @Nullable
    private static Integer getInteger(Map<String, Object> map, String key) {
        if (map.containsKey(key)) {
            Object value = map.get(key);
            if (value != null && value.getClass().isAssignableFrom(Integer.class)) {
                return (Integer) value;
            }
        }

        return null;
    }

    @Nullable
    private static String getString(Map<String, Object> map, String key) {
        if (map.containsKey(key)) {
            Object value = map.get(key);
            if (value != null && value.getClass().isAssignableFrom(String.class)) {
                return (String) value;
            }
        }

        return null;
    }

    @Nullable
    private static Boolean getBoolean(Map<String, Object> map, String key) {
        if (map.containsKey(key)) {
            Object value = map.get(key);
            if (value != null && value.getClass().isAssignableFrom(Boolean.class)) {
                return (Boolean) value;
            }
        }

        return null;
    }
}
