package io.split.splitio;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.split.android.client.impressions.Impression;

public class ImpressionListenerImpTest {

    @Mock
    private MethodChannel mMethodChannel;

    private ImpressionListenerImp mImpressionListener;

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        mImpressionListener = new ImpressionListenerImp(mMethodChannel);
    }

    @Test
    public void loggingInvokesMethodOnMethodChannel() {
        Impression impression = new Impression("key", null, "my_split", "on", 20021002, "on treatment", 1002L, Collections.emptyMap(), "[{\"prop1\", \"value1\"}, {\"prop2\", \"value2\"}]");
        mImpressionListener.log(impression);

        verify(mMethodChannel).invokeMethod(eq("impressionLog"), any());
    }

    @Test
    public void loggingInvokesMethodOnMethodChannelWithCorrectArgument() {
        Impression impression = new Impression("key", null, "my_split", "on", 20021002, "on treatment", 1002L, Collections.singletonMap("age", 25), "[{\"prop1\", \"value1\"}, {\"prop2\", \"value2\"}]");
        Map<String, Object> expectedImpressionMap = new HashMap<>();
        expectedImpressionMap.put("key", "key");
        expectedImpressionMap.put("bucketingKey", null);
        expectedImpressionMap.put("split", "my_split");
        expectedImpressionMap.put("treatment", "on");
        expectedImpressionMap.put("time", 20021002L);
        expectedImpressionMap.put("appliedRule", "on treatment");
        expectedImpressionMap.put("changeNumber", 1002L);
        expectedImpressionMap.put("attributes", Collections.singletonMap("age", 25));
        expectedImpressionMap.put("properties", "[{\"prop1\", \"value1\"}, {\"prop2\", \"value2\"}]");
        mImpressionListener.log(impression);

        verify(mMethodChannel).invokeMethod("impressionLog", expectedImpressionMap);
    }
}
