package io.split.splitio;

import static io.split.splitio.Constants.ARG_API_KEY;
import static io.split.splitio.Constants.ARG_BUCKETING_KEY;
import static io.split.splitio.Constants.ARG_CONFIG;
import static io.split.splitio.Constants.ARG_MATCHING_KEY;
import static io.split.splitio.Constants.ARG_WAIT_FOR_READY;
import static io.split.splitio.Constants.ERROR_SDK_NOT_INITIALIZED;
import static io.split.splitio.Constants.ERROR_SDK_NOT_INITIALIZED_MESSAGE;
import static io.split.splitio.Constants.METHOD_DESTROY;
import static io.split.splitio.Constants.METHOD_GET_CLIENT;
import static io.split.splitio.Constants.METHOD_INIT;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

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
            mSplitWrapper.getClient(matchingKey, bucketingKey, waitForReady, mMethodChannel);

            result.success(null);
        } else {
            result.error(ERROR_SDK_NOT_INITIALIZED, ERROR_SDK_NOT_INITIALIZED_MESSAGE, null);
        }
    }
}
