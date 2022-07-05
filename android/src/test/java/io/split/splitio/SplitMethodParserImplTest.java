package io.split.splitio;

import static org.mockito.ArgumentMatchers.any;
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

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        mMethodParser = new SplitMethodParserImpl(mSplitWrapper, mArgumentParser, mMethodChannel);
    }

    @Test
    public void successfulGetClient() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("waitForReady", true);

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getBooleanArgument("waitForReady", map)).thenReturn(true);
        when(mSplitWrapper.getClient("user-key", "bucketing-key")).thenReturn(mock(SplitClient.class));

        mMethodParser.onMethodCall("getClient", map, mResult);

        verify(mResult).success(null);
        verify(mSplitWrapper).getClient("user-key", "bucketing-key");
    }

    @Test
    public void failingGetClient() {
        mMethodParser = new SplitMethodParserImpl(null, mArgumentParser, mMethodChannel);

        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("waitForReady", true);

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getBooleanArgument("waitForReady", map)).thenReturn(true);

        mMethodParser.onMethodCall("getClient", map, mResult);

        verify(mResult).error("SDK_NOT_INITIALIZED", "Split SDK has not been initialized", null);
        verifyNoInteractions(mSplitWrapper);
    }

    @Test
    public void testCallbackMethodNameAndArgumentsAreCorrect() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("waitForReady", true);

        SplitClient clientMock = mock(SplitClient.class);
        when(clientMock.isReady()).thenReturn(true);

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getBooleanArgument("waitForReady", map)).thenReturn(true);
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
        map.put("waitForReady", true);

        SplitClient clientMock = mock(SplitClient.class);
        when(clientMock.isReady()).thenReturn(true);

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getBooleanArgument("waitForReady", map)).thenReturn(true);
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
    public void destroy() {
        mMethodParser = new SplitMethodParserImpl(mSplitWrapper, mArgumentParser, mMethodChannel);

        mMethodParser.onMethodCall("destroy", Collections.emptyMap(), mResult);

        verify(mSplitWrapper).destroy();
        verify(mResult).success(null);
    }
}
