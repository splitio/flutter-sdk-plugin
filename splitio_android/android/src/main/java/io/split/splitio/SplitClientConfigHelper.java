package io.split.splitio;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import io.split.android.client.ServiceEndpoints;
import io.split.android.client.SplitClientConfig;
import io.split.android.client.SplitFilter;
import io.split.android.client.SyncConfig;
import io.split.android.client.impressions.ImpressionListener;
import io.split.android.client.shared.UserConsent;
import io.split.android.client.utils.logger.SplitLogLevel;

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
    private static final String IMPRESSION_LISTENER = "impressionListener";
    private static final String SYNC_CONFIG = "syncConfig";
    private static final String SYNC_CONFIG_NAMES = "syncConfigNames";
    private static final String SYNC_CONFIG_PREFIXES = "syncConfigPrefixes";
    private static final String SYNC_CONFIG_SETS = "syncConfigFlagSets";
    private static final String IMPRESSIONS_MODE = "impressionsMode";
    private static final String SYNC_ENABLED = "syncEnabled";
    private static final String USER_CONSENT = "userConsent";
    private static final String ENCRYPTION_ENABLED = "encryptionEnabled";
    private static final String LOG_LEVEL = "logLevel";
    private static final String READY_TIMEOUT = "readyTimeout";

    /**
     * Creates a {@link SplitClientConfig} object from a map.
     *
     * @param configurationMap   Map of config values.
     * @param impressionListener Optional ImpressionListener.
     * @return {@link SplitClientConfig} object.
     */
    static SplitClientConfig fromMap(@NonNull Map<String, Object> configurationMap, @Nullable ImpressionListener impressionListener) {
        SplitClientConfig.Builder builder = SplitClientConfig.builder();

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
            builder.logLevel(SplitLogLevel.DEBUG);
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

        if (impressionListener != null) {
            builder.impressionListener(impressionListener);
        }

        Map<String, List<String>> syncConfig = getListMap(configurationMap, SYNC_CONFIG);
        if (syncConfig != null) {
            List<String> names = syncConfig.get(SYNC_CONFIG_NAMES);
            List<String> prefixes = syncConfig.get(SYNC_CONFIG_PREFIXES);
            List<String> flagSets = syncConfig.get(SYNC_CONFIG_SETS);

            SyncConfig.Builder syncConfigBuilder = SyncConfig.builder();
            if (flagSets != null && !flagSets.isEmpty()) {
                syncConfigBuilder.addSplitFilter(SplitFilter.bySet(flagSets));
            } else {
                if (names != null && !names.isEmpty()) {
                    syncConfigBuilder.addSplitFilter(SplitFilter.byName(names));
                }

                if (prefixes != null && !prefixes.isEmpty()) {
                    syncConfigBuilder.addSplitFilter(SplitFilter.byPrefix(prefixes));
                }
            }

            builder.syncConfig(syncConfigBuilder.build());
        }

        String impressionsMode = getString(configurationMap, IMPRESSIONS_MODE);
        if (impressionsMode != null) {
            builder.impressionsMode(impressionsMode);
        }

        Boolean syncEnabled = getBoolean(configurationMap, SYNC_ENABLED);
        if (syncEnabled != null) {
            builder.syncEnabled(syncEnabled);
        }

        String userConsent = getString(configurationMap, USER_CONSENT);
        if (userConsent != null) {
            if ("unknown".equalsIgnoreCase(userConsent)) {
                builder.userConsent(UserConsent.UNKNOWN);
            } else if ("declined".equalsIgnoreCase(userConsent)) {
                builder.userConsent(UserConsent.DECLINED);
            } else {
                builder.userConsent(UserConsent.GRANTED);
            }
        }

        Boolean encryptionEnabled = getBoolean(configurationMap, ENCRYPTION_ENABLED);
        if (encryptionEnabled != null) {
            builder.encryptionEnabled(encryptionEnabled);
        }

        String logLevel = getString(configurationMap, LOG_LEVEL);
        if (logLevel != null) {
            if ("verbose".equalsIgnoreCase(logLevel)) {
                builder.logLevel(SplitLogLevel.VERBOSE);
            } else if ("debug".equalsIgnoreCase(logLevel)) {
                builder.logLevel(SplitLogLevel.DEBUG);
            } else if ("info".equalsIgnoreCase(logLevel)) {
                builder.logLevel(SplitLogLevel.INFO);
            } else if ("warning".equalsIgnoreCase(logLevel)) {
                builder.logLevel(SplitLogLevel.WARNING);
            } else if ("error".equalsIgnoreCase(logLevel)) {
                builder.logLevel(SplitLogLevel.ERROR);
            } else {
                builder.logLevel(SplitLogLevel.NONE);
            }
        }

        Integer readyTimeout = getInteger(configurationMap, READY_TIMEOUT);
        if (readyTimeout != null) {
            builder.ready((int) TimeUnit.SECONDS.toMillis(readyTimeout)); // Android SDK uses this parameter in millis
        }

        return builder.serviceEndpoints(serviceEndpointsBuilder.build()).build();
    }

    static boolean impressionListenerEnabled(@NonNull Map<String, Object> configurationMap) {
        Boolean impressionListenerEnabled = getBoolean(configurationMap, IMPRESSION_LISTENER);
        return impressionListenerEnabled != null && impressionListenerEnabled;
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

    @Nullable
    private static Map<String, List<String>> getListMap(Map<String, Object> map, String key) {
        if (map.containsKey(key)) {
            Object value = map.get(key);
            if (value != null && value.getClass().isAssignableFrom(HashMap.class)) {
                return (HashMap<String, List<String>>) value;
            }
        }

        return null;
    }
}
