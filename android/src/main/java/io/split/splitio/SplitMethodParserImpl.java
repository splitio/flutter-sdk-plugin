package io.split.splitio;

import static io.split.splitio.Constants.ARG_API_KEY;
import static io.split.splitio.Constants.ARG_BUCKETING_KEY;
import static io.split.splitio.Constants.ARG_CONFIG;
import static io.split.splitio.Constants.ARG_MATCHING_KEY;
import static io.split.splitio.Constants.ARG_WAIT_FOR_READY;
import static io.split.splitio.Constants.ERROR_SDK_NOT_INITIALIZED;
import static io.split.splitio.Constants.ERROR_SDK_NOT_INITIALIZED_MESSAGE;
import static io.split.splitio.Constants.METHOD_CLIENT_READY;
import static io.split.splitio.Constants.METHOD_DESTROY;
import static io.split.splitio.Constants.METHOD_GET_CLIENT;
import static io.split.splitio.Constants.METHOD_INIT;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.split.android.client.SplitClient;
import io.split.android.client.events.SplitEvent;
import io.split.android.client.events.SplitEventTask;

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
            case METHOD_INIT:
                initializeSplit(
                        mArgumentParser.getStringArgument(ARG_API_KEY, arguments),
                        mArgumentParser.getStringArgument(ARG_MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(ARG_BUCKETING_KEY, arguments),
                        mArgumentParser.getMapArgument(ARG_CONFIG, arguments),
                        result);
                break;
            case METHOD_GET_CLIENT:
                getClient(
                        mArgumentParser.getStringArgument(ARG_MATCHING_KEY, arguments),
                        mArgumentParser.getStringArgument(ARG_BUCKETING_KEY, arguments),
                        mArgumentParser.getBooleanArgument(ARG_WAIT_FOR_READY, arguments),
                        result);
                break;
            case METHOD_DESTROY:
                mSplitWrapper.destroy();
                result.success(null);
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
            SplitClient client = mSplitWrapper.getClient(matchingKey, bucketingKey, waitForReady);
            addEventListeners(client, matchingKey, bucketingKey, mMethodChannel, waitForReady);

            result.success(null);
        } else {
            result.error(ERROR_SDK_NOT_INITIALIZED, ERROR_SDK_NOT_INITIALIZED_MESSAGE, null);
        }
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
            }

            client.on(SplitEvent.SDK_READY, returnTask);
        } else {
            client.on(SplitEvent.SDK_READY_FROM_CACHE, returnTask);
        }

        client.on(SplitEvent.SDK_READY_TIMED_OUT, returnTask);
    }

    private static void invokeCallback(MethodChannel methodChannel, String matchingKey, @Nullable String bucketingKey) {
        Map<String, String> arguments = new HashMap<>();
        arguments.put(ARG_MATCHING_KEY, matchingKey);
        if (bucketingKey != null) {
            arguments.put(ARG_BUCKETING_KEY, bucketingKey);
        }

        methodChannel.invokeMethod(METHOD_CLIENT_READY, arguments);
    }
}
