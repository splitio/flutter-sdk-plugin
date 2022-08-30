package io.split.splitio;

import android.content.Context;

import androidx.annotation.Nullable;

import io.split.android.client.SplitClientConfig;

interface SplitProviderHelper {

    SplitFactoryProvider getProvider(
            Context context,
            String apiKey,
            String matchingKey,
            @Nullable String bucketingKey,
            SplitClientConfig splitClientConfig);
}

class SplitProviderHelperImpl implements SplitProviderHelper {

    @Nullable private final SplitFactoryProvider mSplitFactoryProvider;

    SplitProviderHelperImpl(@Nullable SplitFactoryProvider splitFactoryProvider) {
        mSplitFactoryProvider = splitFactoryProvider;
    }

    @Override
    public SplitFactoryProvider getProvider(Context context, String apiKey, String matchingKey, @Nullable String bucketingKey, SplitClientConfig splitClientConfig) {
        if (mSplitFactoryProvider != null) {
            return mSplitFactoryProvider;
        }

        return new SplitFactoryProviderImpl(context, apiKey, matchingKey, bucketingKey, splitClientConfig);
    }
}
