package io.split.splitio;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Set;

import io.split.android.client.SplitClient;
import io.split.android.client.SplitFactory;
import io.split.android.client.api.Key;
import io.split.android.client.utils.ConcurrentSet;

class SplitWrapperImpl implements SplitWrapper {

    private final SplitFactory mSplitFactory;
    private final Set<Key> mUsedKeys;

    SplitWrapperImpl(@NonNull SplitFactoryProvider splitFactoryProvider) {
        mSplitFactory = splitFactoryProvider.getSplitFactory();
        mUsedKeys = new ConcurrentSet<>();
    }

    @Override
    public SplitClient getClient(String matchingKey, @Nullable String bucketingKey) {
        Key key = Helper.buildKey(matchingKey, bucketingKey);
        mUsedKeys.add(key);

        return mSplitFactory.client(key);
    }

    @Override
    public void destroy() {
        for (Key key : mUsedKeys) {
            SplitClient client = mSplitFactory.client(key);
            if (client != null) {
                client.destroy();
            }
        }
    }
}
