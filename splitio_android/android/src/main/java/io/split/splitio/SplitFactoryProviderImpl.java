package io.split.splitio;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.split.android.client.SplitClientConfig;
import io.split.android.client.SplitFactory;
import io.split.android.client.SplitFactoryBuilder;
import io.split.android.client.api.Key;
import io.split.android.client.exceptions.SplitInstantiationException;
import io.split.android.client.utils.logger.Logger;

class SplitFactoryProviderImpl implements SplitFactoryProvider {

    private final Context mContext;
    private final Key mKey;
    private final String mApiKey;
    private final SplitClientConfig mSplitClientConfig;
    private volatile SplitFactory mSplitFactory;

    public SplitFactoryProviderImpl(@NonNull Context context,
                                    @NonNull String apiKey,
                                    @NonNull String matchingKey,
                                    @Nullable String bucketingKey,
                                    @NonNull SplitClientConfig splitClientConfig) {
        mContext = context;
        mApiKey = apiKey;
        mKey = Helper.buildKey(matchingKey, bucketingKey);
        mSplitClientConfig = splitClientConfig;
    }

    @Override
    public SplitFactory getSplitFactory() {
        return getInstance();
    }

    private SplitFactory getInstance() {
        if (mSplitFactory == null) {
            synchronized (this) {
                if (mSplitFactory == null) {
                    try {
                        mSplitFactory = SplitFactoryBuilder.build(mApiKey, mKey, mSplitClientConfig, mContext);
                    } catch (SplitInstantiationException e) {
                        Logger.e("Failed to create SplitFactory", e.getLocalizedMessage());
                    }
                }
            }
        }

        return mSplitFactory;
    }
}
