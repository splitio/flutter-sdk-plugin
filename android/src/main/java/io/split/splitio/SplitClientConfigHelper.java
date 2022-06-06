package io.split.splitio;

import java.util.Map;

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
    private static final String CONNECTION_TIME_OUT = "connectionTimeOut";
    private static final String READ_TIMEOUT = "readTimeout";
    private static final String DISABLE_LABELS = "disableLabels";
    private static final String ENABLE_DEBUG = "enableDebug";
    private static final String PROXY_HOST = "proxyHost";
    private static final String READY = "ready";
    private static final String STREAMING_ENABLED = "streamingEnabled";
    private static final String PERSISTENT_ATTRIBUTES_ENABLED = "persistentAttributesEnabled";

    /**
     * Creates a {@link SplitClientConfig} object from a map.
     * @param configurationMap Map of config values.
     * @return {@link SplitClientConfig} object.
     */
    static SplitClientConfig fromMap(Map<String, Object> configurationMap) {
        SplitClientConfig.Builder builder = SplitClientConfig.builder();

        if (configurationMap.containsKey(FEATURES_REFRESH_RATE)) {
            Object featuresRefreshRate = configurationMap.get("featuresRefreshRate");
            if (featuresRefreshRate != null && featuresRefreshRate.getClass().isAssignableFrom(Integer.class)) {
                builder.featuresRefreshRate((Integer) featuresRefreshRate);
            }
        }

        if (configurationMap.containsKey(SEGMENTS_REFRESH_RATE)) {
            Object segmentsRefreshRate = configurationMap.get(SEGMENTS_REFRESH_RATE);
            if (segmentsRefreshRate != null && segmentsRefreshRate.getClass().isAssignableFrom(Integer.class)) {
                builder.segmentsRefreshRate((Integer) segmentsRefreshRate);
            }
        }

        if (configurationMap.containsKey(IMPRESSIONS_REFRESH_RATE)) {
            Object impressionsRefreshRate = configurationMap.get(IMPRESSIONS_REFRESH_RATE);
            if (impressionsRefreshRate != null && impressionsRefreshRate.getClass().isAssignableFrom(Integer.class)) {
                builder.impressionsRefreshRate((Integer) impressionsRefreshRate);
            }
        }

        if (configurationMap.containsKey(TELEMETRY_REFRESH_RATE)) {
            Object telemetryRefreshRate = configurationMap.get(TELEMETRY_REFRESH_RATE);
            if (telemetryRefreshRate != null && telemetryRefreshRate.getClass().isAssignableFrom(Integer.class)) {
                builder.telemetryRefreshRate((Integer) telemetryRefreshRate);
            }
        }

        if (configurationMap.containsKey(EVENTS_QUEUE_SIZE)) {
            Object eventsQueueSize = configurationMap.get(EVENTS_QUEUE_SIZE);
            if (eventsQueueSize != null && eventsQueueSize.getClass().isAssignableFrom(Integer.class)) {
                builder.eventsQueueSize((Integer) eventsQueueSize);
            }
        }

        if (configurationMap.containsKey(IMPRESSIONS_QUEUE_SIZE)) {
            Object impressionsQueueSize = configurationMap.get(IMPRESSIONS_QUEUE_SIZE);
            if (impressionsQueueSize != null && impressionsQueueSize.getClass().isAssignableFrom(Integer.class)) {
                builder.impressionsQueueSize((Integer) impressionsQueueSize);
            }
        }

        if (configurationMap.containsKey(EVENT_FLUSH_INTERVAL)) {
            Object eventFlushInterval = configurationMap.get(EVENT_FLUSH_INTERVAL);
            if (eventFlushInterval != null && eventFlushInterval.getClass().isAssignableFrom(Integer.class)) {
                builder.eventFlushInterval((Integer) eventFlushInterval);
            }
        }

        if (configurationMap.containsKey(EVENTS_PER_PUSH)) {
            Object eventsPerPush = configurationMap.get(EVENTS_PER_PUSH);
            if (eventsPerPush != null && eventsPerPush.getClass().isAssignableFrom(Integer.class)) {
                builder.eventsPerPush((Integer) eventsPerPush);
            }
        }

        if (configurationMap.containsKey(TRAFFIC_TYPE)) {
            Object trafficType = configurationMap.get(TRAFFIC_TYPE);
            if (trafficType != null && trafficType.getClass().isAssignableFrom(String.class)) {
                builder.trafficType((String) trafficType);
            }
        }

        if (configurationMap.containsKey(CONNECTION_TIME_OUT)) {
            Object connectionTimeOut = configurationMap.get(CONNECTION_TIME_OUT);
            if (connectionTimeOut != null && connectionTimeOut.getClass().isAssignableFrom(Integer.class)) {
                builder.connectionTimeout((Integer) connectionTimeOut);
            }
        }

        if (configurationMap.containsKey(READ_TIMEOUT)) {
            Object readTimeout = configurationMap.get(READ_TIMEOUT);
            if (readTimeout != null && readTimeout.getClass().isAssignableFrom(Integer.class)) {
                builder.readTimeout((Integer) readTimeout);
            }
        }

        if (configurationMap.containsKey(DISABLE_LABELS)) {
            Object disableLabels = configurationMap.get(DISABLE_LABELS);
            if (disableLabels != null && disableLabels.getClass().isAssignableFrom(Boolean.class)) {
                if ((Boolean) disableLabels) {
                    builder.disableLabels();
                }
            }
        }

        if (configurationMap.containsKey(ENABLE_DEBUG)) {
            Object enableDebug = configurationMap.get(ENABLE_DEBUG);
            if (enableDebug != null && enableDebug.getClass().isAssignableFrom(Boolean.class)) {
                if ((Boolean) enableDebug) {
                    builder.enableDebug();
                }
            }
        }

        if (configurationMap.containsKey(PROXY_HOST)) {
            Object proxyHost = configurationMap.get(PROXY_HOST);
            if (proxyHost != null && proxyHost.getClass().isAssignableFrom(String.class)) {
                builder.proxyHost((String) proxyHost);
            }
        }

        if (configurationMap.containsKey(READY)) {
            Object ready = configurationMap.get(READY);
            if (ready != null && ready.getClass().isAssignableFrom(Integer.class)) {
                builder.ready((Integer) ready);
            }
        }

        if (configurationMap.containsKey(STREAMING_ENABLED)) {
            Object streamingEnabled = configurationMap.get(STREAMING_ENABLED);
            if (streamingEnabled != null && streamingEnabled.getClass().isAssignableFrom(Boolean.class)) {
                builder.streamingEnabled((Boolean) streamingEnabled);
            }
        }

        if (configurationMap.containsKey(PERSISTENT_ATTRIBUTES_ENABLED)) {
            Object persistentAttributesEnabled = configurationMap.get(PERSISTENT_ATTRIBUTES_ENABLED);
            if (persistentAttributesEnabled != null && persistentAttributesEnabled.getClass().isAssignableFrom(Boolean.class)) {
                builder.persistentAttributesEnabled((Boolean) persistentAttributesEnabled);
            }
        }

        return builder.build();
    }
}
