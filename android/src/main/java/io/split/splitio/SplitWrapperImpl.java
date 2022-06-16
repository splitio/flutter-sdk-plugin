package io.split.splitio;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

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
    public SplitClient getClient(String matchingKey, @Nullable String bucketingKey, boolean waitForReady) {
        Key key = Helper.buildKey(matchingKey, bucketingKey);
        mUsedKeys.add(key);
        SplitClient client = mSplitFactory.client(key);
        waitForReady(client, waitForReady);

        return client;
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

    private void waitForReady(SplitClient client, boolean waitForReady) {
        CountDownLatch latch = new CountDownLatch(1);
        SplitEventTask returnTask = new SplitEventTask() {
            @Override
            public void onPostExecution(SplitClient client) {
                latch.countDown();
            }
        };

        if (waitForReady) {
            if (client.isReady()) {
                return;
            }

            client.on(SplitEvent.SDK_READY, returnTask);
        } else {
            client.on(SplitEvent.SDK_READY_FROM_CACHE, returnTask);
        }
        client.on(SplitEvent.SDK_READY_TIMED_OUT, returnTask);
        try {
            latch.await(10, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
