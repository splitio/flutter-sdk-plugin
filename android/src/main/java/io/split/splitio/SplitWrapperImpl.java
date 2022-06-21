package io.split.splitio;

import static io.split.splitio.Constants.ARG_BUCKETING_KEY;
import static io.split.splitio.Constants.ARG_MATCHING_KEY;
import static io.split.splitio.Constants.METHOD_CLIENT_READY;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.MethodChannel;
import io.split.android.client.SplitClient;
import io.split.android.client.SplitFactory;
import io.split.android.client.api.Key;
import io.split.android.client.events.SplitEvent;
import io.split.android.client.events.SplitEventTask;
import io.split.android.client.utils.ConcurrentSet;

class SplitWrapperImpl implements SplitWrapper {

    private final SplitFactory mSplitFactory;
    private final Set<Key> mUsedKeys;

    SplitWrapperImpl(@NonNull SplitFactoryProvider splitFactoryProvider) {
        mSplitFactory = splitFactoryProvider.getSplitFactory();
        mUsedKeys = new ConcurrentSet<>();
    }

    @Override
    public SplitClient getClient(String matchingKey, @Nullable String bucketingKey, boolean waitForReady, MethodChannel methodChannel) {
        Key key = Helper.buildKey(matchingKey, bucketingKey);
        mUsedKeys.add(key);
        SplitClient client = mSplitFactory.client(key);

        addEventListeners(client, matchingKey, bucketingKey, methodChannel, waitForReady);

        return client;
    }

    private void addEventListeners(SplitClient client, String matchingKey, @Nullable String bucketingKey, MethodChannel methodChannel, boolean waitForReady) {
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

    private void invokeCallback(MethodChannel methodChannel, String matchingKey, @Nullable String bucketingKey) {
        Map<String, String> arguments = new HashMap<>();
        arguments.put(ARG_MATCHING_KEY, matchingKey);
        if (bucketingKey != null) {
            arguments.put(ARG_BUCKETING_KEY, bucketingKey);
        }

        methodChannel.invokeMethod(METHOD_CLIENT_READY, arguments);
    }

    @Override
    public void destroy() {
        for (Key key : mUsedKeys) {
            SplitClient client = mSplitFactory.client(key);
            if (client != null) {
                mUsedKeys.remove(key);
                client.destroy();
            }
        }
    }
}
