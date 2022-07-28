package io.split.splitio;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import io.split.android.client.SplitClientConfig;

public class SplitClientConfigHelperTest {

    @Test
    public void configValuesAreMappedCorrectly() {
        Map<String, Object> configValues = new HashMap<>();

        configValues.put("featuresRefreshRate", 80000);
        configValues.put("segmentsRefreshRate", 70000);
        configValues.put("impressionsRefreshRate", 60000);
        configValues.put("telemetryRefreshRate", 2000);
        configValues.put("eventsQueueSize", 3999);
        configValues.put("impressionsQueueSize", 2999);
        configValues.put("eventFlushInterval", 40000);
        configValues.put("eventsPerPush", 5000);
        configValues.put("trafficType", "none");
        configValues.put("enableDebug", true);
        configValues.put("streamingEnabled", true);
        configValues.put("persistentAttributesEnabled", true);
        configValues.put("apiEndpoint", "apiEndpoint.split.io");
        configValues.put("eventsEndpoint", "eventsEndpoint.split.io");
        configValues.put("sseAuthServiceEndpoint", "sseAuthServiceEndpoint.split.io");
        configValues.put("streamingServiceEndpoint", "streamingServiceEndpoint.split.io");
        configValues.put("telemetryServiceEndpoint", "telemetryServiceEndpoint.split.io");

        SplitClientConfig splitClientConfig = SplitClientConfigHelper.fromMap(configValues);

        assertEquals(80000, splitClientConfig.featuresRefreshRate());
        assertEquals(70000, splitClientConfig.segmentsRefreshRate());
        assertEquals(60000, splitClientConfig.impressionsRefreshRate());
        assertEquals(2000, splitClientConfig.telemetryRefreshRate());
        assertEquals(3999, splitClientConfig.eventsQueueSize());
        assertEquals(2999, splitClientConfig.impressionsQueueSize());
        assertEquals(40000, splitClientConfig.eventFlushInterval());
        assertEquals(5000, splitClientConfig.eventsPerPush());
        assertEquals("none", splitClientConfig.trafficType());
        assertTrue(splitClientConfig.debugEnabled());
        assertTrue(splitClientConfig.streamingEnabled());
        assertTrue(splitClientConfig.persistentAttributesEnabled());
        assertEquals(splitClientConfig.endpoint(), "apiEndpoint.split.io");
        assertEquals(splitClientConfig.eventsEndpoint(), "eventsEndpoint.split.io");
        assertEquals(splitClientConfig.authServiceUrl(), "sseAuthServiceEndpoint.split.io");
        assertEquals(splitClientConfig.streamingServiceUrl(), "streamingServiceEndpoint.split.io");
        assertEquals(splitClientConfig.telemetryEndpoint(), "telemetryServiceEndpoint.split.io");
    }
}
