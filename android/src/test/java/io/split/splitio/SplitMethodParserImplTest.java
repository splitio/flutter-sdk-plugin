package io.split.splitio;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.split.android.client.SplitClient;

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
        when(mSplitWrapper.getClient("user-key", "bucketing-key", true)).thenReturn(mock(SplitClient.class));

        mMethodParser.onMethodCall("getClient", map, mResult);

        verify(mResult).success(null);
        verify(mSplitWrapper).getClient("user-key", "bucketing-key", true);
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
        when(mSplitWrapper.getClient("user-key", "bucketing-key", true)).thenReturn(clientMock);

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
        when(mSplitWrapper.getClient("user-key", null, true)).thenReturn(clientMock);

        mMethodParser.onMethodCall("getClient", map, mResult);

        Map<String, String> args = new HashMap<>();
        args.put("matchingKey", "user-key");
        verify(mMethodChannel).invokeMethod("clientReady", args);
        verify(mResult).success(null);
    }

    @Test
    public void destroy() {
        mMethodParser = new SplitMethodParserImpl(mSplitWrapper, mArgumentParser, mMethodChannel);

        mMethodParser.onMethodCall("destroy", Collections.emptyMap(), mResult);

        verify(mSplitWrapper).destroy();
        verify(mResult).success(null);
    }
}
