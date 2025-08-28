package io.split.splitio;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import androidx.annotation.NonNull;

import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.ArgumentMatcher;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.MethodChannel;
import io.split.android.client.EvaluationOptions;
import io.split.android.client.SplitClient;
import io.split.android.client.SplitResult;
import io.split.android.client.api.SplitView;
import io.split.android.client.dtos.Prerequisite;

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
    private SplitProviderHelper mProviderHelper;

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        mMethodParser = new SplitMethodParserImpl(mSplitWrapper, mArgumentParser, mMethodChannel, mProviderHelper);
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
        verify(mSplitWrapper).getClient(eq("user-key"), eq("bucketing-key"));
    }

    @Test
    public void failingGetClient() {
        mMethodParser = new SplitMethodParserImpl(null, mArgumentParser, mMethodChannel, mProviderHelper);

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
        when(mArgumentParser.getMapArgument("evaluationOptions", map)).thenReturn(Collections.singletonMap("boolean", true));
        when(mSplitWrapper.getTreatment(any(), any(), any(), any(), any())).thenReturn("on");

        mMethodParser.onMethodCall("getTreatment", map, mResult);

        verify(mSplitWrapper).getTreatment(eq("user-key"), eq((String) null), eq("split-name"), eq(Collections.singletonMap("age", 10)), 
                argThat(evaluationOptionsPropertiesMatcher()));
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
        when(mArgumentParser.getMapArgument("evaluationOptions", map)).thenReturn(Collections.singletonMap("boolean", true));
        when(mSplitWrapper.getTreatments(any(), any(), any(), any(), any())).thenReturn(expectedResponse);

        mMethodParser.onMethodCall("getTreatments", map, mResult);

        verify(mSplitWrapper).getTreatments(eq("user-key"), eq((String) null), eq(Arrays.asList("split1", "split2")), eq(Collections.singletonMap("age", 10)), 
                argThat(evaluationOptionsPropertiesMatcher()));
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
        when(mArgumentParser.getMapArgument("evaluationOptions", map)).thenReturn(Collections.singletonMap("boolean", true));
        when(mSplitWrapper.getTreatmentsWithConfig(any(), any(), any(), any(), any())).thenReturn(mockResult);

        mMethodParser.onMethodCall("getTreatmentsWithConfig", map, mResult);

        verify(mSplitWrapper).getTreatmentsWithConfig(eq("user-key"), eq("bucketing-key"), eq(Arrays.asList("split1", "split2")), eq(Collections.singletonMap("age", 10)), 
                argThat(evaluationOptionsPropertiesMatcher()));
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
        when(mArgumentParser.getMapArgument("evaluationOptions", map)).thenReturn(Collections.singletonMap("boolean", true));
        when(mSplitWrapper.getTreatmentWithConfig(any(), any(), any(), any(), any())).thenReturn(new SplitResult("on", "{config}"));

        mMethodParser.onMethodCall("getTreatmentWithConfig", map, mResult);

        verify(mSplitWrapper).getTreatmentWithConfig(eq("user-key"), eq("bucketing-key"), eq("split-name"), eq(Collections.singletonMap("age", 10)), 
                argThat(evaluationOptionsPropertiesMatcher()));
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

        verify(mSplitWrapper).track(eq("user-key"), eq("bucketing-key"), eq("my-event"), eq((String) null), eq(25.20), eq(Collections.emptyMap()));
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

        verify(mSplitWrapper).track(eq("user-key"), eq("bucketing-key"), eq("my-event"), eq((String) null), eq((Double) null), eq(Collections.emptyMap()));
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

        verify(mSplitWrapper).track(eq("user-key"), eq("bucketing-key"), eq("my-event"), eq((String) null), eq(25.20), eq(Collections.singletonMap("age", 50)));
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

        verify(mSplitWrapper).track(eq("user-key"), eq("bucketing-key"), eq("my-event"), eq("account"), eq(25.20), eq(Collections.singletonMap("age", 50)));
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

        verify(mSplitWrapper).getAttribute(eq("user-key"), eq("bucketing-key"), eq("my_attribute"));
    }

    @Test
    public void getAllAttributes() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");

        mMethodParser.onMethodCall("getAllAttributes", map, mResult);

        verify(mSplitWrapper).getAllAttributes(eq("user-key"), eq("bucketing-key"));
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

        verify(mSplitWrapper).setAttribute(eq("user-key"), eq("bucketing-key"), eq("my_attr"), eq("attr_value"));
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

        verify(mSplitWrapper).setAttributes(eq("user-key"), eq("bucketing-key"), eq(attributesMap));
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

        verify(mSplitWrapper).removeAttribute(eq("user-key"), eq("bucketing-key"), eq("my_attr"));
    }

    @Test
    public void clearAttributes() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");

        mMethodParser.onMethodCall("clearAttributes", map, mResult);

        verify(mSplitWrapper).clearAttributes(eq("user-key"), eq("bucketing-key"));
    }

    @Test
    public void flush() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");

        mMethodParser.onMethodCall("flush", map, mResult);

        verify(mSplitWrapper).flush(eq("user-key"), eq("bucketing-key"));
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

        verify(mSplitWrapper).destroy(eq("user-key"), eq("bucketing-key"));
        verify(mResult).success(null);
    }

    @Test
    public void splitViews() {
        Prerequisite prerequisite1 = mock(Prerequisite.class);
        when(prerequisite1.getFlagName()).thenReturn("flag1");
        when(prerequisite1.getTreatments()).thenReturn(new HashSet<>(Arrays.asList("on", "true")));
        
        Prerequisite prerequisite2 = mock(Prerequisite.class);
        when(prerequisite2.getFlagName()).thenReturn("flag2");
        when(prerequisite2.getTreatments()).thenReturn(new HashSet<>(Arrays.asList("on", "true")));
        
        List<Prerequisite> prerequisites = Arrays.asList(prerequisite1, prerequisite2);

        SplitView splitView = mock(SplitView.class);
        splitView.name = "test_split";
        splitView.trafficType = "user";
        splitView.killed = false;
        splitView.treatments = Arrays.asList("on", "off");
        splitView.changeNumber = 123L;
        splitView.configs = Collections.singletonMap("on", "{\"color\": \"blue\"}");
        splitView.defaultTreatment = "off";
        splitView.sets = Arrays.asList("set1", "set2");
        splitView.prerequisites = prerequisites;
        splitView.impressionsDisabled = true;
        
        when(mSplitWrapper.splits()).thenReturn(Arrays.asList(splitView));
        
        mMethodParser.onMethodCall("splits", Collections.emptyMap(), mResult);
        
        verify(mSplitWrapper).splits();
        
        // Verify that the result includes the correctly formatted prerequisites
        ArgumentCaptor<List<Map<String, Object>>> captor = ArgumentCaptor.forClass(List.class);
        verify(mResult).success(captor.capture());
        
        List<Map<String, Object>> result = captor.getValue();
        assertEquals(1, result.size());
        
        Map<String, Object> splitViewMap = result.get(0);
        
        // Verify all SplitView fields are correctly mapped
        assertEquals("test_split", splitViewMap.get("name"));
        assertEquals("user", splitViewMap.get("trafficType"));
        assertEquals(false, splitViewMap.get("killed"));
        assertEquals(Arrays.asList("on", "off"), splitViewMap.get("treatments"));
        assertEquals(123L, splitViewMap.get("changeNumber"));
        assertEquals(Collections.singletonMap("on", "{\"color\": \"blue\"}"), splitViewMap.get("configs"));
        assertEquals("off", splitViewMap.get("defaultTreatment"));
        assertEquals(Arrays.asList("set1", "set2"), splitViewMap.get("sets"));
        assertEquals(true, splitViewMap.get("impressionsDisabled"));
        
        // Verify prerequisites
        assertTrue(splitViewMap.containsKey("prerequisites"));
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> prerequisitesResult = (List<Map<String, Object>>) splitViewMap.get("prerequisites");
        assertEquals(2, prerequisitesResult.size());
        
        // Verify first prerequisite
        Map<String, Object> prereq1 = prerequisitesResult.get(0);
        assertEquals("flag1", prereq1.get("n"));
        Set<String> treatments = (Set<String>) prereq1.get("t");
        assertEquals(2, treatments.size());
        assertTrue(treatments.contains("on"));
        assertTrue(treatments.contains("true"));
        
        // Verify second prerequisite
        Map<String, Object> prereq2 = prerequisitesResult.get(1);
        assertEquals("flag2", prereq2.get("n"));
        Set<String> treatments1 = (Set<String>) prereq2.get("t");
        assertEquals(2, treatments1.size());
        assertTrue(treatments1.contains("on"));
        assertTrue(treatments1.contains("true"));
    }

    @Test
    public void splitNames() {
        mMethodParser.onMethodCall("splitNames", Collections.emptyMap(), mResult);

        verify(mSplitWrapper).splitNames();
    }

    @Test
    public void split() {
        when(mArgumentParser.getStringArgument(eq("splitName"), any())).thenReturn("my_split");

        mMethodParser.onMethodCall("split", Collections.singletonMap("splitName", "my_split"), mResult);

        verify(mSplitWrapper).split(eq("my_split"));
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
        when(mProviderHelper.getProvider(any(), any(), any(), any(), any())).thenReturn(splitFactoryProvider);

        mMethodParser.onMethodCall("init", arguments, mResult);

        verify(mProviderHelper).getProvider(any(),
                eq("key"),
                eq("matching-key"),
                eq("bucketing-key"),
                argThat(splitClientConfig -> splitClientConfig.impressionListener() != null && !splitClientConfig.streamingEnabled()));
    }

    @Test
    public void getUserConsent() {
        when(mSplitWrapper.getUserConsent()).thenReturn("granted");
        mMethodParser.onMethodCall("getUserConsent", Collections.emptyMap(), mResult);

        verify(mResult).success("granted");
        verify(mSplitWrapper).getUserConsent();
    }

    @Test
    public void setUserConsentEnabled() {
        when(mArgumentParser.getBooleanArgument("value", Collections.singletonMap("value", true))).thenReturn(true);
        when(mArgumentParser.getBooleanArgument("value", Collections.singletonMap("value", false))).thenReturn(false);
        mMethodParser.onMethodCall("setUserConsent", Collections.singletonMap("value", true), mResult);

        verify(mResult).success(null);
        verify(mSplitWrapper).setUserConsent(eq(true));
    }

    @Test
    public void setUserConsentDisabled() {
        when(mArgumentParser.getBooleanArgument("value", Collections.singletonMap("value", true))).thenReturn(true);
        when(mArgumentParser.getBooleanArgument("value", Collections.singletonMap("value", false))).thenReturn(false);
        mMethodParser.onMethodCall("setUserConsent", Collections.singletonMap("value", false), mResult);

        verify(mResult).success(null);
        verify(mSplitWrapper).setUserConsent(eq(false));
    }

    @Test
    public void getTreatmentsByFlagSetWorksCorrectly() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("flagSet", "set_1");
        map.put("attributes", Collections.singletonMap("age", 10));

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringArgument("flagSet", map)).thenReturn("set_1");
        when(mArgumentParser.getMapArgument("attributes", map)).thenReturn(Collections.singletonMap("age", 10));
        when(mArgumentParser.getMapArgument("evaluationOptions", map)).thenReturn(Collections.singletonMap("boolean", true));
        when(mSplitWrapper.getTreatmentsByFlagSet(any(), any(), any(), any(), any())).thenReturn(Collections.singletonMap("flag_1", "on"));

        mMethodParser.onMethodCall("getTreatmentsByFlagSet", map, mResult);

        verify(mSplitWrapper).getTreatmentsByFlagSet(eq("user-key"), eq("bucketing-key"), eq("set_1"), eq(Collections.singletonMap("age", 10)),
                argThat(evaluationOptionsPropertiesMatcher()));
        verify(mResult).success(Collections.singletonMap("flag_1", "on"));
    }

    @Test
    public void getTreatmentsByFlagSetsWorksCorrectly() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("flagSets", Arrays.asList("set_1", "set_2"));
        map.put("attributes", Collections.singletonMap("age", 10));

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringListArgument("flagSets", map)).thenReturn(Arrays.asList("set_1", "set_2"));
        when(mArgumentParser.getMapArgument("attributes", map)).thenReturn(Collections.singletonMap("age", 10));
        when(mArgumentParser.getMapArgument("evaluationOptions", map)).thenReturn(Collections.singletonMap("boolean", true));
        when(mSplitWrapper.getTreatmentsByFlagSets(any(), any(), any(), any(), any())).thenReturn(Collections.singletonMap("flag_1", "on"));

        mMethodParser.onMethodCall("getTreatmentsByFlagSets", map, mResult);

        verify(mSplitWrapper).getTreatmentsByFlagSets(eq("user-key"), eq("bucketing-key"), eq(Arrays.asList("set_1", "set_2")), eq(Collections.singletonMap("age", 10)), 
                argThat(evaluationOptionsPropertiesMatcher()));
        verify(mResult).success(Collections.singletonMap("flag_1", "on"));
    }

    @Test
    public void getTreatmentsWithConfigByFlagSetWorksCorrectly() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("flagSet", "set_1");
        map.put("attributes", Collections.singletonMap("age", 10));

        Map<String, String> resultMap1 = new HashMap<>();
        resultMap1.put("treatment", "on");
        resultMap1.put("config", "{config}");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringArgument("flagSet", map)).thenReturn("set_1");
        when(mArgumentParser.getMapArgument("attributes", map)).thenReturn(Collections.singletonMap("age", 10));
        when(mArgumentParser.getMapArgument("evaluationOptions", map)).thenReturn(Collections.singletonMap("boolean", true));
        when(mSplitWrapper.getTreatmentsWithConfigByFlagSet(any(), any(), any(), any(), any())).thenReturn(Collections.singletonMap("flag_1", new SplitResult("on", "{config}")));

        mMethodParser.onMethodCall("getTreatmentsWithConfigByFlagSet", map, mResult);

        verify(mSplitWrapper).getTreatmentsWithConfigByFlagSet(eq("user-key"), eq("bucketing-key"), eq("set_1"), eq(Collections.singletonMap("age", 10)), 
                argThat(evaluationOptionsPropertiesMatcher()));
        verify(mResult).success(Collections.singletonMap("flag_1", resultMap1));
    }

    @Test
    public void getTreatmentsWithConfigByFlagSetsWorksCorrectly() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", "user-key");
        map.put("bucketingKey", "bucketing-key");
        map.put("flagSets", Arrays.asList("set_1", "set_2"));
        map.put("attributes", Collections.singletonMap("age", 10));

        Map<String, String> resultMap1 = new HashMap<>();
        resultMap1.put("treatment", "on");
        resultMap1.put("config", "{config}");

        when(mArgumentParser.getStringArgument("matchingKey", map)).thenReturn("user-key");
        when(mArgumentParser.getStringArgument("bucketingKey", map)).thenReturn("bucketing-key");
        when(mArgumentParser.getStringListArgument("flagSets", map)).thenReturn(Arrays.asList("set_1", "set_2"));
        when(mArgumentParser.getMapArgument("attributes", map)).thenReturn(Collections.singletonMap("age", 10));
        when(mArgumentParser.getMapArgument("evaluationOptions", map)).thenReturn(Collections.singletonMap("boolean", true));
        when(mSplitWrapper.getTreatmentsWithConfigByFlagSets(any(), any(), any(), any(), any())).thenReturn(Collections.singletonMap("flag_1", new SplitResult("on", "{config}")));

        mMethodParser.onMethodCall("getTreatmentsWithConfigByFlagSets", map, mResult);

        verify(mSplitWrapper).getTreatmentsWithConfigByFlagSets(eq("user-key"), eq("bucketing-key"), eq(Arrays.asList("set_1", "set_2")), eq(Collections.singletonMap("age", 10)), 
                argThat(evaluationOptionsPropertiesMatcher()));
        verify(mResult).success(Collections.singletonMap("flag_1", resultMap1));
    }

    @NonNull
    private static ArgumentMatcher<EvaluationOptions> evaluationOptionsPropertiesMatcher() {
        return options -> options != null && options.getProperties().size() == 1 && options.getProperties().containsKey("boolean") && (Boolean) options.getProperties().get("boolean");
    }
}
