package io.split.splitio;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;

import org.junit.Test;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.split.android.client.SplitClientConfig;
import io.split.android.client.SplitFilter;
import io.split.android.client.impressions.ImpressionListener;
import io.split.android.client.service.impressions.ImpressionsMode;
import io.split.android.client.shared.UserConsent;
import io.split.android.client.utils.logger.SplitLogLevel;

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
        configValues.put("sdkEndpoint", "apiEndpoint.split.io");
        configValues.put("eventsEndpoint", "eventsEndpoint.split.io");
        configValues.put("authServiceEndpoint", "sseAuthServiceEndpoint.split.io");
        configValues.put("streamingServiceEndpoint", "streamingServiceEndpoint.split.io");
        configValues.put("telemetryServiceEndpoint", "telemetryServiceEndpoint.split.io");
        Map<String, List<String>> syncConfigMap = new HashMap<>();
        syncConfigMap.put("syncConfigNames", Arrays.asList("split1", "split2"));
        syncConfigMap.put("syncConfigPrefixes", Arrays.asList("split_", "my_split_"));
        configValues.put("syncConfig", syncConfigMap);
        configValues.put("impressionsMode", "none");
        configValues.put("syncEnabled", false);
        configValues.put("userConsent", "declined");
        configValues.put("encryptionEnabled", true);
        configValues.put("logLevel", "verbose");

        SplitClientConfig splitClientConfig = SplitClientConfigHelper
                .fromMap(configValues, mock(ImpressionListener.class));

        assertEquals(80000, splitClientConfig.featuresRefreshRate());
        assertEquals(70000, splitClientConfig.segmentsRefreshRate());
        assertEquals(60000, splitClientConfig.impressionsRefreshRate());
        assertEquals(2000, splitClientConfig.telemetryRefreshRate());
        assertEquals(3999, splitClientConfig.eventsQueueSize());
        assertEquals(2999, splitClientConfig.impressionsQueueSize());
        assertEquals(40000, splitClientConfig.eventFlushInterval());
        assertEquals(5000, splitClientConfig.eventsPerPush());
        assertEquals("none", splitClientConfig.trafficType());
        assertTrue(splitClientConfig.streamingEnabled());
        assertTrue(splitClientConfig.persistentAttributesEnabled());
        assertEquals("apiEndpoint.split.io", splitClientConfig.endpoint());
        assertEquals("eventsEndpoint.split.io", splitClientConfig.eventsEndpoint());
        assertEquals("sseAuthServiceEndpoint.split.io", splitClientConfig.authServiceUrl());
        assertEquals("streamingServiceEndpoint.split.io", splitClientConfig.streamingServiceUrl());
        assertEquals("telemetryServiceEndpoint.split.io", splitClientConfig.telemetryEndpoint());
        assertEquals(Arrays.asList("split1", "split2"), splitClientConfig.syncConfig().getFilters().get(0).getValues());
        assertEquals(SplitFilter.Type.BY_NAME, splitClientConfig.syncConfig().getFilters().get(0).getType());
        assertEquals(Arrays.asList("split_", "my_split_"), splitClientConfig.syncConfig().getFilters().get(1).getValues());
        assertEquals(SplitFilter.Type.BY_PREFIX, splitClientConfig.syncConfig().getFilters().get(1).getType());
        assertEquals(ImpressionsMode.NONE, splitClientConfig.impressionsMode());
        assertFalse(splitClientConfig.syncEnabled());
        assertEquals(UserConsent.DECLINED, splitClientConfig.userConsent());
        assertTrue(splitClientConfig.encryptionEnabled());
        assertEquals(SplitLogLevel.VERBOSE, splitClientConfig.logLevel());
    }

    @Test
    public void enableDebugLogLevelIsMappedCorrectly() {
        Map<String, Object> configValues = new HashMap<>();

        configValues.put("enableDebug", true);

        SplitClientConfig splitClientConfig = SplitClientConfigHelper
                .fromMap(configValues, mock(ImpressionListener.class));

        assertEquals(SplitLogLevel.DEBUG, splitClientConfig.logLevel());
    }

    @Test
    public void logLevelsAreMappedCorrectly() {
        Map<String, Object> verboseConfigValues = Collections.singletonMap("logLevel", "verbose");
        Map<String, Object> debugConfigValues = Collections.singletonMap("logLevel", "debug");
        Map<String, Object> infoConfigValues = Collections.singletonMap("logLevel", "info");
        Map<String, Object> warnConfigValues = Collections.singletonMap("logLevel", "warning");
        Map<String, Object> errorConfigValues = Collections.singletonMap("logLevel", "error");
        Map<String, Object> noneConfigValues = Collections.singletonMap("logLevel", "none");

        SplitClientConfig verboseConfig = SplitClientConfigHelper
                .fromMap(verboseConfigValues, mock(ImpressionListener.class));
        SplitClientConfig debugConfig = SplitClientConfigHelper.fromMap(debugConfigValues, mock(ImpressionListener.class));
        SplitClientConfig infoConfig = SplitClientConfigHelper.fromMap(infoConfigValues, mock(ImpressionListener.class));
        SplitClientConfig warnConfig = SplitClientConfigHelper.fromMap(warnConfigValues, mock(ImpressionListener.class));
        SplitClientConfig errorConfig = SplitClientConfigHelper.fromMap(errorConfigValues, mock(ImpressionListener.class));
        SplitClientConfig noneConfig = SplitClientConfigHelper.fromMap(noneConfigValues, mock(ImpressionListener.class));

        assertEquals(SplitLogLevel.VERBOSE, verboseConfig.logLevel());
        assertEquals(SplitLogLevel.DEBUG, debugConfig.logLevel());
        assertEquals(SplitLogLevel.INFO, infoConfig.logLevel());
        assertEquals(SplitLogLevel.WARNING, warnConfig.logLevel());
        assertEquals(SplitLogLevel.ERROR, errorConfig.logLevel());
        assertEquals(SplitLogLevel.NONE, noneConfig.logLevel());
    }

    @Test
    public void userConsentIsMappedCorrectly() {
        SplitClientConfig grantedConfig = SplitClientConfigHelper
                .fromMap(Collections.singletonMap("userConsent", "granted"), mock(ImpressionListener.class));
        SplitClientConfig unknownConfig = SplitClientConfigHelper
                .fromMap(Collections.singletonMap("userConsent", "unknown"), mock(ImpressionListener.class));
        SplitClientConfig declinedConfig = SplitClientConfigHelper
                .fromMap(Collections.singletonMap("userConsent", "declined"), mock(ImpressionListener.class));
        SplitClientConfig anyConfig = SplitClientConfigHelper
                .fromMap(Collections.singletonMap("userConsent", "any"), mock(ImpressionListener.class));

        assertEquals(UserConsent.GRANTED, grantedConfig.userConsent());
        assertEquals(UserConsent.UNKNOWN, unknownConfig.userConsent());
        assertEquals(UserConsent.DECLINED, declinedConfig.userConsent());
        assertEquals(UserConsent.GRANTED, anyConfig.userConsent());
    }

    @Test
    public void impressionsModeValuesAreMappedCorrectly() {
        SplitClientConfig debugConfig = SplitClientConfigHelper
                .fromMap(Collections.singletonMap("impressionsMode", "debug"), mock(ImpressionListener.class));
        SplitClientConfig noneConfig = SplitClientConfigHelper
                .fromMap(Collections.singletonMap("impressionsMode", "none"), mock(ImpressionListener.class));
        SplitClientConfig optimizedConfig = SplitClientConfigHelper
                .fromMap(Collections.singletonMap("impressionsMode", "optimized"), mock(ImpressionListener.class));

        assertEquals(ImpressionsMode.DEBUG, debugConfig.impressionsMode());
        assertEquals(ImpressionsMode.NONE, noneConfig.impressionsMode());
        assertEquals(ImpressionsMode.OPTIMIZED, optimizedConfig.impressionsMode());
    }
}
