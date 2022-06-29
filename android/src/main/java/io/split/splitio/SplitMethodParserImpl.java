package io.split.splitio;

import static io.split.splitio.Constants.Argument.API_KEY;
import static io.split.splitio.Constants.Argument.ATTRIBUTES;
import static io.split.splitio.Constants.Argument.BUCKETING_KEY;
import static io.split.splitio.Constants.Argument.EVENT_TYPE;
import static io.split.splitio.Constants.Argument.PROPERTIES;
import static io.split.splitio.Constants.Argument.SDK_CONFIGURATION;
import static io.split.splitio.Constants.Argument.MATCHING_KEY;
import static io.split.splitio.Constants.Argument.SPLIT_NAME;
import static io.split.splitio.Constants.Argument.TRAFFIC_TYPE;
import static io.split.splitio.Constants.Argument.VALUE;
import static io.split.splitio.Constants.Argument.WAIT_FOR_READY;
import static io.split.splitio.Constants.Error.SDK_NOT_INITIALIZED;
import static io.split.splitio.Constants.Error.SDK_NOT_INITIALIZED_MESSAGE;
import static io.split.splitio.Constants.Method.CLIENT_READY;
import static io.split.splitio.Constants.Method.DESTROY;
import static io.split.splitio.Constants.Method.CLIENT;
import static io.split.splitio.Constants.Method.GET_TREATMENT;
import static io.split.splitio.Constants.Method.GET_TREATMENTS;
import static io.split.splitio.Constants.Method.GET_TREATMENTS_WITH_CONFIG;
import static io.split.splitio.Constants.Method.GET_TREATMENT_WITH_CONFIG;
import static io.split.splitio.Constants.Method.INIT;
import static io.split.splitio.Constants.Method.TRACK;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.split.android.client.SplitClient;
import io.split.android.client.SplitResult;
import io.split.android.client.events.SplitEvent;
import io.split.android.client.events.SplitEventTask;
import io.split.android.client.utils.Logger;

class SplitMethodParserImpl implements SplitMethodParser {

    private Context mContext;
    private SplitWrapper mSplitWrapper;
    private final ArgumentParser mArgumentParser;
    private final MethodChannel mMethodChannel;

    public SplitMethodParserImpl(@NonNull Context context, MethodChannel channel) {
        mContext = context;
        mArgumentParser = new ArgumentParserImpl();
        mMethodChannel = channel;
    }

    @VisibleForTesting
    public SplitMethodParserImpl(@NonNull SplitWrapper splitWrapper,
                                 @NonNull ArgumentParser argumentParser,
                                 @NonNull MethodChannel channel) {
        mSplitWrapper = splitWrapper;
        mArgumentParser = argumentParser;
        mMethodChannel = channel;
    }

    @Override
    public void onMethodCall(String methodName, Object arguments, @NonNull MethodChannel.Result result) {
        switch (methodName) {
            case INIT:
                initializeSplit(
                        mArgumentParser.getStringArgument(API_KEY, arguments),
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getMapArgument(SDK_CONFIGURATION, arguments),
                        result);
                break;
            case CLIENT:
                getClient(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getBooleanArgument(WAIT_FOR_READY, arguments),
                        result);
                break;
            case GET_TREATMENT:
                getTreatment(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringArgument(SPLIT_NAME, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments),
                        result);
                break;
            case GET_TREATMENTS:
                getTreatments(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringListArgument(SPLIT_NAME, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments),
                        result);
                break;
            case GET_TREATMENT_WITH_CONFIG:
                getTreatmentWithConfig(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringArgument(SPLIT_NAME, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments),
                        result);
                break;
            case GET_TREATMENTS_WITH_CONFIG:
                getTreatmentsWithConfig(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringListArgument(SPLIT_NAME, arguments),
                        mArgumentParser.getMapArgument(ATTRIBUTES, arguments),
                        result);
                break;
            case TRACK:
                track(
                        mArgumentParser.getStringArgument(MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(BUCKETING_KEY, arguments),
                        mArgumentParser.getStringArgument(EVENT_TYPE, arguments),
                        mArgumentParser.getStringArgument(TRAFFIC_TYPE, arguments),
                        mArgumentParser.getDoubleArgument(VALUE, arguments),
                        mArgumentParser.getMapArgument(PROPERTIES, arguments),
                        result);
                break;
            case DESTROY:
                mSplitWrapper.destroy();
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void initializeSplit(String apiKey, String matchingKey, String bucketingKey, Map<String, Object> mapArgument, MethodChannel.Result result) {
        mSplitWrapper = new SplitWrapperImpl(new SplitFactoryProviderImpl(
                mContext, apiKey, matchingKey, bucketingKey, SplitClientConfigHelper.fromMap(mapArgument)
        ));
        result.success(null);
    }

    private void getClient(String matchingKey, String bucketingKey, boolean waitForReady, MethodChannel.Result result) {
        if (mSplitWrapper != null) {
            SplitClient client = mSplitWrapper.getClient(matchingKey, bucketingKey);
            addEventListeners(client, matchingKey, bucketingKey, mMethodChannel, waitForReady);

            result.success(null);
        } else {
            result.error(SDK_NOT_INITIALIZED, SDK_NOT_INITIALIZED_MESSAGE, null);
        }
    }

    private void getTreatment(String matchingKey,
                              String bucketingKey,
                              String splitName,
                              Map<String, Object> attributes,
                              MethodChannel.Result result) {
        String treatment = mSplitWrapper.getTreatment(matchingKey, bucketingKey, splitName, attributes);
        result.success(treatment);
    }

    private void getTreatments(String matchingKey,
                               String bucketingKey,
                               List<String> splitNames,
                               Map<String, Object> attributes,
                               MethodChannel.Result result) {
        Map<String, String> treatments = mSplitWrapper.getTreatments(matchingKey, bucketingKey, splitNames, attributes);
        result.success(treatments);
    }

    private void getTreatmentWithConfig(
            String matchingKey,
            String bucketingKey,
            String splitName,
            Map<String, Object> attributes,
            MethodChannel.Result result) {
        SplitResult treatment = mSplitWrapper.getTreatmentWithConfig(matchingKey, bucketingKey, splitName, attributes);
        result.success(Collections.singletonMap(splitName, getSplitResultMap(treatment)));
    }

    private void getTreatmentsWithConfig(
            String matchingKey,
            String bucketingKey,
            List<String> splitNames,
            Map<String, Object> attributes,
            MethodChannel.Result result) {
        Map<String, SplitResult> treatmentsWithConfig = mSplitWrapper.getTreatmentsWithConfig(matchingKey, bucketingKey, splitNames, attributes);
        Map<String, Map<String, String>> resultMap = new HashMap<>();

        for (Map.Entry<String, SplitResult> entry : treatmentsWithConfig.entrySet()) {
            resultMap.put(entry.getKey(), getSplitResultMap(entry.getValue()));
        }

        result.success(resultMap);
    }

    private void track(String matchingKey,
                       String bucketingKey,
                       String eventType,
                       @Nullable String trafficType,
                       @Nullable Double value,
                       Map<String, Object> properties,
                       MethodChannel.Result result) {
        result.success(mSplitWrapper.track(matchingKey, bucketingKey, eventType,trafficType,value, properties));
    }

    private static void addEventListeners(SplitClient client, String matchingKey, @Nullable String bucketingKey, MethodChannel methodChannel, boolean waitForReady) {
        SplitEventTask returnTask = new SplitEventTask() {
            @Override
            public void onPostExecutionView(SplitClient client) {
                invokeCallback(methodChannel, matchingKey, bucketingKey);
            }
        };

        if (waitForReady) {
            if (client.isReady()) {
                invokeCallback(methodChannel, matchingKey, bucketingKey);
            } else {
                client.on(SplitEvent.SDK_READY, returnTask);
            }
        } else {
            client.on(SplitEvent.SDK_READY_FROM_CACHE, returnTask);
        }

        client.on(SplitEvent.SDK_READY_TIMED_OUT, returnTask);
    }

    private static void invokeCallback(MethodChannel methodChannel, String matchingKey, @Nullable String bucketingKey) {
        final Map<String, String> arguments = new HashMap<>();
        arguments.put(MATCHING_KEY, matchingKey);
        if (bucketingKey != null) {
            arguments.put(BUCKETING_KEY, bucketingKey);
        }

        methodChannel.invokeMethod(CLIENT_READY, arguments);
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
}
