package io.split.splitio;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.split.android.client.SplitClient;
import io.split.android.client.SplitResult;

public class SplitMethodParserImplTest {

    private SplitMethodParserImpl mMethodParser;
    @Mock
    private SplitWrapper mSplitWrapper;
    @Mock
    private ArgumentParser mArgumentParser;
    @Mock
    private MethodChannel.Result mResult;
    @Mock
    private MethodChannel mMethodChannel;
    @Mock
    private SplitProviderHelper mProviderFactory;

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        mMethodParser = new SplitMethodParserImpl(mSplitWrapper, mArgumentParser, mMethodChannel, mProviderFactory);
    }

    @Test
    public void successfulGetClient() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mSplitWrapper.getClient("user-key", "bucketing-key")).thenReturn(mock(SplitClient.class));

        mMethodParser.onMethodCall("getClient", map, mResult);

        verify(mResult).success(null);
        verify(mSplitWrapper).getClient("user-key", "bucketing-key");
    }

    @Test
    public void failingGetClient() {
        mMethodParser = new SplitMethodParserImpl(null, mArgumentParser, mMethodChannel, mProviderFactory);

        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");

        mMethodParser.onMethodCall("getClient", map, mResult);

        verify(mResult).error("SDK_NOT_INITIALIZED", "Split SDK has not been initialized", null);
        verifyNoInteractions(mSplitWrapper);
    }

    @Test
    public void testReadyCallbackMethodNameAndArgumentsAreCorrect() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");

        SplitClient clientMock = mock(SplitClient.class);
        when(clientMock.isReady()).thenReturn(true);

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mSplitWrapper.getClient("user-key", "bucketing-key")).thenReturn(clientMock);

        mMethodParser.onMethodCall("getClient", map, mResult);

        Map<String, String> args = new HashMap<>();
        args.put("matchingKey", "user-key");
        args.put("bucketingKey", "bucketing-key");
        verify(mMethodChannel).invokeMethod("clientReady", args);
        verify(mResult).success(null);
    }

    @Test
    public void testCallbackMethodNameAndArgumentsAreCorrectWithoutBucketingKey() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");

        SplitClient clientMock = mock(SplitClient.class);
        when(clientMock.isReady()).thenReturn(true);

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mSplitWrapper.getClient("user-key", null)).thenReturn(clientMock);

        mMethodParser.onMethodCall("getClient", map, mResult);

        Map<String, String> args = new HashMap<>();
        args.put("matchingKey", "user-key");
        verify(mMethodChannel).invokeMethod("clientReady", args);
        verify(mResult).success(null);
    }

    @Test
    public void getTreatmentWorksCorrectly() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("splitName", "split-name");
        map.put("attributes", Collections.singletonMap("age", 10));

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn(null);
        when(mArgumentParser.getStringArgument("splitName", map)).thenReturn("split-name");
        when(mArgumentParser.getMapArgument("attributes", map)).thenReturn(Collections.singletonMap("age", 10));
        when(mSplitWrapper.getTreatment(any(), any(), any(), any())).thenReturn("on");

        mMethodParser.onMethodCall("getTreatment", map, mResult);

        verify(mSplitWrapper).getTreatment("user-key", null, "split-name", Collections.singletonMap("age", 10));
        verify(mResult).success("on");
    }

    @Test
    public void getTreatmentsWorksCorrectly() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("splitName", Arrays.asList("split1", "split2"));
        map.put("attributes", Collections.singletonMap("age", 10));

        Map<String, String> expectedResponse = new HashMap<>();
        expectedResponse.put("split1", "on");
        expectedResponse.put("split2", "off");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn(null);
        when(mArgumentParser.getStringListArgument("splitName", map)).thenReturn(Arrays.asList("split1", "split2"));
        when(mArgumentParser.getMapArgument("attributes", map)).thenReturn(Collections.singletonMap("age", 10));
        when(mSplitWrapper.getTreatments(any(), any(), any(), any())).thenReturn(expectedResponse);

        mMethodParser.onMethodCall("getTreatments", map, mResult);

        verify(mSplitWrapper).getTreatments("user-key", null, Arrays.asList("split1", "split2"), Collections.singletonMap("age", 10));
        verify(mResult).success(expectedResponse);
    }

    @Test
    public void getTreatmentsWithConfigWorksCorrectly() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("splitName", Arrays.asList("split1", "split2"));
        map.put("attributes", Collections.singletonMap("age", 10));

        Map<String, SplitResult> mockResult = new HashMap<>();
        mockResult.put("split1", new SplitResult("on", "{config}"));
        mockResult.put("split2", new SplitResult("off", "{config}"));

        Map<String, String> resultMap1 = new HashMap<>();
        resultMap1.put("treatment", "on");
        resultMap1.put("config", "{config}");
        Map<String, String> resultMap2 = new HashMap<>();
        resultMap2.put("treatment", "off");
        resultMap2.put("config", "{config}");
        Map<String, Map<String, String>> finalResultMap = new HashMap<>();
        finalResultMap.put("split1", resultMap1);
        finalResultMap.put("split2", resultMap2);

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringListArgument("splitName", map)).thenReturn(Arrays.asList("split1", "split2"));
        when(mArgumentParser.getMapArgument("attributes", map)).thenReturn(Collections.singletonMap("age", 10));
        when(mSplitWrapper.getTreatmentsWithConfig(any(), any(), any(), any())).thenReturn(mockResult);

        mMethodParser.onMethodCall("getTreatmentsWithConfig", map, mResult);

        verify(mSplitWrapper).getTreatmentsWithConfig("user-key", "bucketing-key", Arrays.asList("split1", "split2"), Collections.singletonMap("age", 10));
        verify(mResult).success(finalResultMap);
    }

    @Test
    public void getTreatmentWithConfigWorksCorrectly() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("splitName", "split-name");
        map.put("attributes", Collections.singletonMap("age", 10));

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringArgument("splitName", map)).thenReturn("split-name");
        when(mArgumentParser.getMapArgument("attributes", map)).thenReturn(Collections.singletonMap("age", 10));
        when(mSplitWrapper.getTreatmentWithConfig(any(), any(), any(), any())).thenReturn(new SplitResult("on", "{config}"));

        mMethodParser.onMethodCall("getTreatmentWithConfig", map, mResult);

        verify(mSplitWrapper).getTreatmentWithConfig("user-key", "bucketing-key", "split-name", Collections.singletonMap("age", 10));
        Map<String, String> resultMap = new HashMap<>();
        resultMap.put("treatment", "on");
        resultMap.put("config", "{config}");

        verify(mResult).success(Collections.singletonMap("split-name", resultMap));
    }

    @Test
    public void trackWithValue() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("eventType", "my-event");
        map.put("value", 25.20);

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringArgument("eventType", map)).thenReturn("my-event");
        when(mArgumentParser.getDoubleArgument("value", map)).thenReturn(25.20);

        mMethodParser.onMethodCall("track", map, mResult);

        verify(mSplitWrapper).track("user-key", "bucketing-key", "my-event", null, 25.20, Collections.emptyMap());
    }

    @Test
    public void trackWithInvalidValue() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("eventType", "my-event");
        map.put("value", "25.20");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringArgument("eventType", map)).thenReturn("my-event");
        when(mArgumentParser.getDoubleArgument("value", map)).thenReturn(null);

        mMethodParser.onMethodCall("track", map, mResult);

        verify(mSplitWrapper).track("user-key", "bucketing-key", "my-event", null, null, Collections.emptyMap());
    }

    @Test
    public void trackWithValueAndProperties() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("eventType", "my-event");
        map.put("value", 25.20);
        map.put("properties", Collections.singletonMap("age", 50));

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringArgument("eventType", map)).thenReturn("my-event");
        when(mArgumentParser.getDoubleArgument("value", map)).thenReturn(25.20);
        when(mArgumentParser.getMapArgument("properties", map)).thenReturn(Collections.singletonMap("age", 50));

        mMethodParser.onMethodCall("track", map, mResult);

        verify(mSplitWrapper).track("user-key", "bucketing-key", "my-event", null, 25.20, Collections.singletonMap("age", 50));
    }

    @Test
    public void trackWithEverything() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("eventType", "my-event");
        map.put("value", 25.20);
        map.put("properties", Collections.singletonMap("age", 50));
        map.put("trafficType", "account");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringArgument("eventType", map)).thenReturn("my-event");
        when(mArgumentParser.getDoubleArgument("value", map)).thenReturn(25.20);
        when(mArgumentParser.getMapArgument("properties", map)).thenReturn(Collections.singletonMap("age", 50));
        when(mArgumentParser.getStringArgument("trafficType", map)).thenReturn("account");

        mMethodParser.onMethodCall("track", map, mResult);

        verify(mSplitWrapper).track("user-key", "bucketing-key", "my-event", "account", 25.20, Collections.singletonMap("age", 50));
    }

    @Test
    public void getSingleAttribute() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("attributeName", "my_attribute");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringArgument("attributeName", map)).thenReturn("my_attribute");

        mMethodParser.onMethodCall("getAttribute", map, mResult);

        verify(mSplitWrapper).getAttribute("user-key", "bucketing-key", "my_attribute");
    }

    @Test
    public void getAllAttributes() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");

        mMethodParser.onMethodCall("getAllAttributes", map, mResult);

        verify(mSplitWrapper).getAllAttributes("user-key", "bucketing-key");
    }

    @Test
    public void setSingleAttribute() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("attributeName", "my_attr");
        map.put("value", "attr_value");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringArgument("attributeName", map)).thenReturn("my_attr");
        when(mArgumentParser.getObjectArgument("value", map)).thenReturn("attr_value");

        mMethodParser.onMethodCall("setAttribute", map, mResult);

        verify(mSplitWrapper).setAttribute("user-key", "bucketing-key", "my_attr", "attr_value");
    }

    @Test
    public void setMultipleAttributes() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("attributeName", "my_attr");

        Map<String, Object> attributesMap = new HashMap<>();
        attributesMap.put("bool_attr", true);
        attributesMap.put("number_attr", 25.56);
        attributesMap.put("string_attr", "attr-value");
        attributesMap.put("list_attr", Arrays.asList("one", "two"));

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getMapArgument("attributes", map)).thenReturn(attributesMap);

        mMethodParser.onMethodCall("setAttributes", map, mResult);

        verify(mSplitWrapper).setAttributes("user-key", "bucketing-key", attributesMap);
    }

    @Test
    public void removeAttribute() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("attributeName", "my_attr");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringArgument("attributeName", map)).thenReturn("my_attr");

        mMethodParser.onMethodCall("removeAttribute", map, mResult);

        verify(mSplitWrapper).removeAttribute("user-key", "bucketing-key", "my_attr");
    }

    @Test
    public void clearAttributes() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");

        mMethodParser.onMethodCall("clearAttributes", map, mResult);

        verify(mSplitWrapper).clearAttributes("user-key", "bucketing-key");
    }

    @Test
    public void flush() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");

        mMethodParser.onMethodCall("flush", map, mResult);

        verify(mSplitWrapper).flush("user-key", "bucketing-key");
        verify(mResult).success(null);
    }

    @Test
    public void destroy() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");

        mMethodParser.onMethodCall("destroy", map, mResult);

        verify(mSplitWrapper).destroy("user-key", "bucketing-key");
        verify(mResult).success(null);
    }

    @Test
    public void splitNames() {
        mMethodParser.onMethodCall("splitNames", Collections.emptyMap(), mResult);

        verify(mSplitWrapper).splitNames();
    }

    @Test
    public void splits() {
        mMethodParser.onMethodCall("splits", Collections.emptyMap(), mResult);

        verify(mSplitWrapper).splits();
    }

    @Test
    public void split() {
        when(mArgumentParser.getStringArgument(eq("splitName"), any())).thenReturn("my_split");

        mMethodParser.onMethodCall("split", Collections.singletonMap("splitName", "my_split"), mResult);

        verify(mSplitWrapper).split("my_split");
    }

    @Test
    public void initialization() {
        Map<String, Object> configurationMap = new HashMap<>();
        configurationMap.put("streamingEnabled", false);
        configurationMap.put("impressionListener", true);

        Map<String, Object> arguments = new HashMap<>();
        arguments.put("apiKey", "key");
        arguments.put("matchingKey", "matching-key");
        arguments.put("bucketingKey", "bucketing-key");
        arguments.put("sdkConfiguration", configurationMap);

        when(mArgumentParser.getStringArgument("apiKey", arguments)).thenReturn("key");
        when(mArgumentParser.getStringArgument("matchingKey", arguments)).thenReturn("matching-key");
        when(mArgumentParser.getStringArgument("bucketingKey", arguments)).thenReturn("bucketing-key");
        when(mArgumentParser.getMapArgument("sdkConfiguration", arguments)).thenReturn(configurationMap);

        SplitFactoryProvider splitFactoryProvider = mock(SplitFactoryProvider.class);
        when(mProviderFactory.getProvider(any(), any(), any(), any(), any())).thenReturn(splitFactoryProvider);

        mMethodParser.onMethodCall("init", arguments, mResult);

        verify(mProviderFactory).getProvider(any(),
                eq("key"),
                eq("matching-key"),
                eq("bucketing-key"),
                argThat(splitClientConfig -> splitClientConfig.impressionListener() != null && !splitClientConfig.streamingEnabled()));
    }
}
