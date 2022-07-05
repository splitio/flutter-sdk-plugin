package io.split.splitio;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.List;
import java.util.Map;
import java.util.Set;

import io.split.android.client.SplitClient;
import io.split.android.client.SplitFactory;
import io.split.android.client.SplitResult;
import io.split.android.client.api.Key;
import io.split.android.client.utils.ConcurrentSet;
import io.split.android.client.utils.Logger;

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
        SplitClient client = mSplitFactory.client(matchingKey, bucketingKey);
        mUsedKeys.add(key);

        return client;
    }

    @Override
    public boolean track(String matchingKey, @Nullable String bucketingKey, String eventType, @Nullable String trafficType, @Nullable Double value, Map<String, Object> properties) {
        SplitClient client = getClient(matchingKey, bucketingKey);
        if (trafficType != null) {
            if (value != null) {
                return client.track(trafficType, eventType, value, properties);
            } else {
                return client.track(trafficType, eventType, properties);
            }
        }

        if (value != null) {
            return client.track(eventType, value, properties);
        } else {
            return client.track(eventType, properties);
        }
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

    @Override
    public String getTreatment(String matchingKey, String bucketingKey, String splitName, Map<String, Object> attributes) {
        return getClient(matchingKey, bucketingKey).getTreatment(splitName, attributes);
    }

    @Override
    public Map<String, String> getTreatments(String matchingKey, String bucketingKey, List<String> splitNames, Map<String, Object> attributes) {
        return getClient(matchingKey, bucketingKey).getTreatments(splitNames, attributes);
    }

    @Override
    public SplitResult getTreatmentWithConfig(String matchingKey, String bucketingKey, String splitName, Map<String, Object> attributes) {
        return getClient(matchingKey, bucketingKey).getTreatmentWithConfig(splitName, attributes);
    }

    @Override
    public Map<String, SplitResult> getTreatmentsWithConfig(String matchingKey, String bucketingKey, List<String> splitNames, Map<String, Object> attributes) {
        return getClient(matchingKey, bucketingKey).getTreatmentsWithConfig(splitNames, attributes);
    }
}
