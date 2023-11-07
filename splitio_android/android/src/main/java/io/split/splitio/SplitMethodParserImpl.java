package io.split.splitio;

import static io.split.splitio.Constants.Argument.API_KEY;
import static io.split.splitio.Constants.Argument.ATTRIBUTES;
import static io.split.splitio.Constants.Argument.ATTRIBUTE_NAME;
import static io.split.splitio.Constants.Argument.BUCKETING_KEY;
import static io.split.splitio.Constants.Argument.EVENT_TYPE;
import static io.split.splitio.Constants.Argument.FLAG_SET;
import static io.split.splitio.Constants.Argument.FLAG_SETS;
import static io.split.splitio.Constants.Argument.MATCHING_KEY;
import static io.split.splitio.Constants.Argument.PROPERTIES;
import static io.split.splitio.Constants.Argument.SDK_CONFIGURATION;
import static io.split.splitio.Constants.Argument.SPLIT_NAME;
import static io.split.splitio.Constants.Argument.TRAFFIC_TYPE;
import static io.split.splitio.Constants.Argument.VALUE;
import static io.split.splitio.Constants.Error.SDK_NOT_INITIALIZED;
import static io.split.splitio.Constants.Error.SDK_NOT_INITIALIZED_MESSAGE;
import static io.split.splitio.Constants.Method.CLEAR_ATTRIBUTES;
import static io.split.splitio.Constants.Method.CLIENT;
import static io.split.splitio.Constants.Method.CLIENT_READY;
import static io.split.splitio.Constants.Method.CLIENT_READY_FROM_CACHE;
import static io.split.splitio.Constants.Method.CLIENT_TIMEOUT;
import static io.split.splitio.Constants.Method.CLIENT_UPDATED;
import static io.split.splitio.Constants.Method.DESTROY;
import static io.split.splitio.Constants.Method.FLUSH;
import static io.split.splitio.Constants.Method.GET_ALL_ATTRIBUTES;
import static io.split.splitio.Constants.Method.GET_ATTRIBUTE;
import static io.split.splitio.Constants.Method.GET_TREATMENT;
import static io.split.splitio.Constants.Method.GET_TREATMENTS;
import static io.split.splitio.Constants.Method.GET_TREATMENTS_BY_FLAG_SET;
import static io.split.splitio.Constants.Method.GET_TREATMENTS_BY_FLAG_SETS;
import static io.split.splitio.Constants.Method.GET_TREATMENTS_WITH_CONFIG;
import static io.split.splitio.Constants.Method.GET_TREATMENTS_WITH_CONFIG_BY_FLAG_SET;
import static io.split.splitio.Constants.Method.GET_TREATMENTS_WITH_CONFIG_BY_FLAG_SETS;
import static io.split.splitio.Constants.Method.GET_TREATMENT_WITH_CONFIG;
import static io.split.splitio.Constants.Method.GET_USER_CONSENT;
import static io.split.splitio.Constants.Method.INIT;
import static io.split.splitio.Constants.Method.REMOVE_ATTRIBUTE;
import static io.split.splitio.Constants.Method.SET_ATTRIBUTE;
import static io.split.splitio.Constants.Method.SET_ATTRIBUTES;
import static io.split.splitio.Constants.Method.SET_USER_CONSENT;
import static io.split.splitio.Constants.Method.SPLIT;
import static io.split.splitio.Constants.Method.SPLITS;
import static io.split.splitio.Constants.Method.SPLIT_NAMES;
import static io.split.splitio.Constants.Method.TRACK;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.split.android.client.SplitClient;
import io.split.android.client.SplitResult;
import io.split.android.client.api.SplitView;
import io.split.android.client.events.SplitEvent;
import io.split.android.client.events.SplitEventTask;

class SplitMethodParserImpl implements SplitMethodParser {

    private Context mContext;
    private SplitWrapper mSplitWrapper;
    private final ArgumentParser mArgumentParser;
    private final MethodChannel mMethodChannel;
    private final SplitProviderHelper mProviderHelper;

    public SplitMethodParserImpl(@NonNull Context context, @NonNull MethodChannel channel, @Nullable SplitFactoryProvider splitFactoryProvider) {
        mContext = context;
        mArgumentParser = new ArgumentParserImpl();
        mMethodChannel = channel;
        mProviderHelper = new SplitProviderHelperImpl(splitFactoryProvider);
    }

    @VisibleForTesting
    public SplitMethodParserImpl(@NonNull SplitWrapper splitWrapper,
                                 @NonNull ArgumentParser argumentParser,
                                 @NonNull MethodChannel channel,
                                 @NonNull SplitProviderHelper providerHelper) {
        mSplitWrapper = splitWrapper;
        mArgumentParser = argumentParser;
        mMethodChannel = channel;
        mProviderHelper = providerHelper;
    }

    @Override
    public void onMethodCall(String methodName, Object arguments, @NonNull MethodChannel.Result result) {
        switch (methodName) {
            case INIT:
                initializeSplit(
                        mArgumentParser.getStringArgument(API_KEY, arguments),
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getMapArgument(SDK_CONFIGURATION, arguments));
                result.success(null);
                break;
            case CLIENT:
                SplitClient client = getClient(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments));
                if (client != null) {
                    result.success(null);
                } else {
                    result.error(SDK_NOT_INITIALIZED, SDK_NOT_INITIALIZED_MESSAGE, null);
                }
                break;
            case GET_TREATMENT:
                result.success(getTreatment(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringArgument(SPLIT_NAME, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments)));
                break;
            case GET_TREATMENTS:
                result.success(getTreatments(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringListArgument(SPLIT_NAME, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments)));
                break;
            case GET_TREATMENT_WITH_CONFIG:
                result.success(getTreatmentWithConfig(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringArgument(SPLIT_NAME, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments)));
                break;
            case GET_TREATMENTS_WITH_CONFIG:
                result.success(getTreatmentsWithConfig(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringListArgument(SPLIT_NAME, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments)));
                break;
            case GET_TREATMENTS_BY_FLAG_SET:
                result.success(getTreatmentsByFlagSet(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringArgument(FLAG_SET, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments)));
                break;
            case GET_TREATMENTS_BY_FLAG_SETS:
                result.success(getTreatmentsByFlagSets(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringListArgument(FLAG_SETS, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments)));
                break;
            case GET_TREATMENTS_WITH_CONFIG_BY_FLAG_SET:
                result.success(getTreatmentsWithConfigByFlagSet(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringArgument(FLAG_SET, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments)));
                break;
            case GET_TREATMENTS_WITH_CONFIG_BY_FLAG_SETS:
                result.success(getTreatmentsWithConfigByFlagSets(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringListArgument(FLAG_SETS, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments)));
                break;
            case TRACK:
                result.success(track(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringArgument(EVENT_TYPE, arguments),
                        mArgumentParser.getStringArgument(TRAFFIC_TYPE, arguments),
                        mArgumentParser.getDoubleArgument(VALUE, arguments),
                        mArgumentParser.getMapArgument(PROPERTIES, arguments)));
                break;
            case GET_ATTRIBUTE:
                result.success(getAttribute(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringArgument(ATTRIBUTE_NAME, arguments)));
                break;
            case GET_ALL_ATTRIBUTES:
                result.success(getAllAttributes(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments)));
                break;
            case SET_ATTRIBUTE:
                result.success(setAttribute(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringArgument(ATTRIBUTE_NAME, arguments),
                        mArgumentParser.getObjectArgument(VALUE, arguments)));
                break;
            case SET_ATTRIBUTES:
                result.success(setAttributes(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments)));
                break;
            case REMOVE_ATTRIBUTE:
                result.success(removeAttribute(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringArgument(ATTRIBUTE_NAME, arguments)));
                break;
            case CLEAR_ATTRIBUTES:
                result.success(clearAttributes(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments)));
                break;
            case FLUSH:
                mSplitWrapper.flush(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments));
                result.success(null);
                break;
            case DESTROY:
                mSplitWrapper.destroy(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments));
                result.success(null);
                break;
            case SPLIT_NAMES:
                result.success(mSplitWrapper.splitNames());
                break;
            case SPLITS:
                result.success(getSplitViewsAsMap(mSplitWrapper.splits()));
                break;
            case SPLIT:
                result.success(getSplitViewAsMap(mSplitWrapper.split(mArgumentParser.getStringArgument(SPLIT_NAME, arguments))));
                break;
            case GET_USER_CONSENT:
                result.success(mSplitWrapper.getUserConsent());
                break;
            case SET_USER_CONSENT:
                mSplitWrapper.setUserConsent(mArgumentParser.getBooleanArgument(VALUE, arguments));
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void initializeSplit(String apiKey, String matchingKey, String bucketingKey, Map<String, Object> mapArgument) {
        mSplitWrapper = new SplitWrapperImpl(mProviderHelper.getProvider(
                mContext,
                apiKey,
                matchingKey,
                bucketingKey,
                SplitClientConfigHelper.fromMap(mapArgument,
                        getImpressionListener(SplitClientConfigHelper.impressionListenerEnabled(mapArgument)))));
    }

    @Nullable
    private ImpressionListenerImp getImpressionListener(boolean impressionListenerEnabled) {
        if (impressionListenerEnabled) {
            return new ImpressionListenerImp(mMethodChannel);
        }

        return null;
    }

    private SplitClient getClient(String matchingKey, String bucketingKey) {
        if (mSplitWrapper != null) {
            SplitClient client = mSplitWrapper.getClient(matchingKey, bucketingKey);
            addEventListeners(client, matchingKey, bucketingKey, mMethodChannel);

            return client;
        }

        return null;
    }

    private String getTreatment(String matchingKey,
                                String bucketingKey,
                                String splitName,
                                Map<String, Object> attributes) {
        return mSplitWrapper.getTreatment(matchingKey, bucketingKey, splitName, attributes);
    }

    private Map<String, String> getTreatments(String matchingKey,
                                              String bucketingKey,
                                              List<String> splitNames,
                                              Map<String, Object> attributes) {
        return mSplitWrapper.getTreatments(matchingKey, bucketingKey, splitNames, attributes);
    }

    private Map<String, Map<String, String>> getTreatmentWithConfig(
            String matchingKey,
            String bucketingKey,
            String splitName,
            Map<String, Object> attributes) {
        SplitResult treatment = mSplitWrapper.getTreatmentWithConfig(matchingKey, bucketingKey, splitName, attributes);

        return Collections.singletonMap(splitName, getSplitResultMap(treatment));
    }

    private Map<String, Map<String, String>> getTreatmentsWithConfig(
            String matchingKey,
            String bucketingKey,
            List<String> splitNames,
            Map<String, Object> attributes) {
        Map<String, SplitResult> treatmentsWithConfig = mSplitWrapper.getTreatmentsWithConfig(matchingKey, bucketingKey, splitNames, attributes);
        return mapToSplitResults(treatmentsWithConfig);
    }

    private Map<String, String> getTreatmentsByFlagSet(
            String matchingKey,
            String bucketingKey,
            String flagSet,
            Map<String, Object> attributes) {
        return mSplitWrapper.getTreatmentsByFlagSet(matchingKey, bucketingKey, flagSet, attributes);
    }

    private Map<String, String> getTreatmentsByFlagSets(
            String matchingKey,
            String bucketingKey,
            List<String> flagSets,
            Map<String, Object> attributes) {
        return mSplitWrapper.getTreatmentsByFlagSets(matchingKey, bucketingKey, flagSets, attributes);
    }

    private Map<String, Map<String, String>> getTreatmentsWithConfigByFlagSet(
            String matchingKey,
            String bucketingKey,
            String flagSet,
            Map<String, Object> attributes) {
        Map<String, SplitResult> treatmentsWithConfig = mSplitWrapper.getTreatmentsWithConfigByFlagSet(matchingKey, bucketingKey, flagSet, attributes);
        return mapToSplitResults(treatmentsWithConfig);
    }

    private Map<String, Map<String, String>> getTreatmentsWithConfigByFlagSets(
            String matchingKey,
            String bucketingKey,
            List<String> flagSets,
            Map<String, Object> attributes) {
        Map<String, SplitResult> treatmentsWithConfig = mSplitWrapper.getTreatmentsWithConfigByFlagSets(matchingKey, bucketingKey, flagSets, attributes);
        return mapToSplitResults(treatmentsWithConfig);
    }

    private boolean track(String matchingKey,
                          String bucketingKey,
                          String eventType,
                          @Nullable String trafficType,
                          @Nullable Double value,
                          Map<String, Object> properties) {
        return mSplitWrapper.track(matchingKey, bucketingKey, eventType, trafficType, value, properties);
    }

    private Object getAttribute(String matchingKey, String bucketingKey, String attributeName) {
        return mSplitWrapper.getAttribute(matchingKey, bucketingKey, attributeName);
    }

    private Map<String, Object> getAllAttributes(String matchingKey, String bucketingKey) {
        return mSplitWrapper.getAllAttributes(matchingKey, bucketingKey);
    }

    private boolean setAttribute(String matchingKey, String bucketingKey, String attributeName, Object attributeValue) {
        return mSplitWrapper.setAttribute(matchingKey, bucketingKey, attributeName, attributeValue);
    }

    private boolean setAttributes(String matchingKey, String bucketingKey, Map<String, Object> attributes) {
        return mSplitWrapper.setAttributes(matchingKey, bucketingKey, attributes);
    }

    private boolean removeAttribute(String matchingKey, String buketingKey, String attributeName) {
        return mSplitWrapper.removeAttribute(matchingKey, buketingKey, attributeName);
    }

    private boolean clearAttributes(String matchingKey, String bucketingKey) {
        return mSplitWrapper.clearAttributes(matchingKey, bucketingKey);
    }

    private static void addEventListeners(SplitClient client, String matchingKey, @Nullable String bucketingKey, MethodChannel methodChannel) {
        if (client.isReady()) {
            invokeCallback(methodChannel, matchingKey, bucketingKey, CLIENT_READY);
        }

        client.on(SplitEvent.SDK_READY, new SplitEventTask() {
            @Override
            public void onPostExecutionView(SplitClient client) {
                invokeCallback(methodChannel, matchingKey, bucketingKey, CLIENT_READY);
            }
        });

        client.on(SplitEvent.SDK_READY_FROM_CACHE, new SplitEventTask() {
            @Override
            public void onPostExecutionView(SplitClient client) {
                invokeCallback(methodChannel, matchingKey, bucketingKey, CLIENT_READY_FROM_CACHE);
            }
        });

        client.on(SplitEvent.SDK_READY_TIMED_OUT, new SplitEventTask() {
            @Override
            public void onPostExecutionView(SplitClient client) {
                invokeCallback(methodChannel, matchingKey, bucketingKey, CLIENT_TIMEOUT);
            }
        });

        client.on(SplitEvent.SDK_UPDATE, new SplitEventTask() {
            @Override
            public void onPostExecutionView(SplitClient client) {
                invokeCallback(methodChannel, matchingKey, bucketingKey, CLIENT_UPDATED);
            }
        });
    }

    private static void invokeCallback(MethodChannel methodChannel, String matchingKey, @Nullable String bucketingKey, String methodName) {
        final Map<String, String> arguments = new HashMap<>();
        arguments.put(MATCHING_KEY, matchingKey);
        if (bucketingKey != null) {
            arguments.put(BUCKETING_KEY, bucketingKey);
        }

        methodChannel.invokeMethod(methodName, arguments);
    }

    @NonNull
    private static Map<String, Map<String, String>> mapToSplitResults(Map<String, SplitResult> treatmentsWithConfig) {
        Map<String, Map<String, String>> resultMap = new HashMap<>();

        for (Map.Entry<String, SplitResult> entry : treatmentsWithConfig.entrySet()) {
            resultMap.put(entry.getKey(), getSplitResultMap(entry.getValue()));
        }

        return resultMap;
    }

    private static Map<String, String> getSplitResultMap(SplitResult splitResult) {
        if (splitResult == null) {
            return new HashMap<>();
        }

        Map<String, String> splitResultMap = new HashMap<>();

        splitResultMap.put("treatment", splitResult.treatment());
        splitResultMap.put("config", splitResult.config());

        return splitResultMap;
    }

    private static List<Map<String, Object>> getSplitViewsAsMap(List<SplitView> splitViews) {
        List<Map<String, Object>> splitViewsResultMap = new ArrayList<>();

        for (SplitView splitView : splitViews) {
            Map<String, Object> splitViewMap = getSplitViewAsMap(splitView);
            if (splitViewMap != null) {
                splitViewsResultMap.add(splitViewMap);
            }
        }

        return splitViewsResultMap;
    }

    @Nullable
    private static Map<String, Object> getSplitViewAsMap(@Nullable SplitView splitView) {
        if (splitView == null) {
            return null;
        }

        Map<String, Object> splitViewMap = new HashMap<>();
        splitViewMap.put("name", splitView.name);
        splitViewMap.put("trafficType", splitView.trafficType);
        splitViewMap.put("killed", splitView.killed);
        splitViewMap.put("treatments", splitView.treatments);
        splitViewMap.put("changeNumber", splitView.changeNumber);
        splitViewMap.put("configs", splitView.configs);
        splitViewMap.put("defaultTreatment", splitView.defaultTreatment);
        splitViewMap.put("sets", splitView.sets);

        return splitViewMap;
    }
}
