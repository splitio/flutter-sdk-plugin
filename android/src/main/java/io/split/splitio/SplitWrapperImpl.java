package io.split.splitio;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.Set;
import java.util.concurrent.TimeoutException;

import io.split.android.client.SplitClient;
import io.split.android.client.SplitClientConfig;
import io.split.android.client.SplitFactory;
import io.split.android.client.SplitFactoryBuilder;
import io.split.android.client.api.Key;
import io.split.android.client.utils.ConcurrentSet;

class SplitWrapperImpl implements SplitWrapper {

    private final SplitFactory mSplitFactory;
    private final Set<Key> mUsedKeys;

    SplitWrapperImpl(@NonNull Context context,
                     @NonNull String apikey,
                     @NonNull String matchingKey,
                     @Nullable String bucketingKey,
                     @NonNull SplitClientConfig splitClientConfig) throws SplitInitializationException {
        try {
            mSplitFactory = SplitFactoryBuilder.build(apikey,
                    buildKey(matchingKey, bucketingKey),
                    splitClientConfig,
                    context);

            mUsedKeys = new ConcurrentSet<>();
        } catch (IOException | InterruptedException | TimeoutException | URISyntaxException e) {
            throw new SplitInitializationException(e.getMessage());
        }
    }

    @Override
    public SplitClient getClient(String matchingKey, @Nullable String bucketingKey) {
        Key key = buildKey(matchingKey, bucketingKey);
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

    @NonNull
    private Key buildKey(String matchingKey, @Nullable String bucketingKey) {
        if (bucketingKey != null && !bucketingKey.isEmpty()) {
            return new Key(matchingKey, bucketingKey);
        }

        return new Key(matchingKey);
    }
}
