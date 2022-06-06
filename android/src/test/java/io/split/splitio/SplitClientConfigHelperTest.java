package io.split.splitio;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
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
        configValues.put("connectionTimeOut", 10);
        configValues.put("readTimeout", 25);
        configValues.put("disableLabels", true);
        configValues.put("enableDebug", true);
        configValues.put("proxyHost", "https://proxy");
        configValues.put("ready", 25);
        configValues.put("streamingEnabled", true);
        configValues.put("persistentAttributesEnabled", true);
        configValues.put("apiEndpoint", "https://apiEndpoint");
        configValues.put("eventsEndpoint", "https://eventsEndpoint");
        configValues.put("sseAuthServiceEndpoint", "https://sseAuthServiceEndpoint");
        configValues.put("streamingServiceEndpoint", "https://streamingServiceEndpoint");
        configValues.put("telemetryServiceEndpoint", "https://telemetryServiceEndpoint");

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
        assertEquals(10, splitClientConfig.connectionTimeout());
        assertEquals(25, splitClientConfig.readTimeout());
        assertFalse(splitClientConfig.labelsEnabled());
        assertTrue(splitClientConfig.debugEnabled());
        assertEquals("proxy", splitClientConfig.proxy().getHost());
        assertEquals(25, splitClientConfig.readTimeout());
        assertTrue(splitClientConfig.streamingEnabled());
        assertTrue(splitClientConfig.persistentAttributesEnabled());
        assertEquals("https://sseAuthServiceEndpoint", splitClientConfig.authServiceUrl());
        assertEquals("https://streamingServiceEndpoint", splitClientConfig.streamingServiceUrl());
        assertEquals("https://telemetryServiceEndpoint", splitClientConfig.telemetryEndpoint());
        assertEquals("https://apiEndpoint", splitClientConfig.endpoint());
        assertEquals("https://eventsEndpoint", splitClientConfig.eventsEndpoint());
    }
}
