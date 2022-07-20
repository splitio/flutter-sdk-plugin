package io.split.splitio;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import java.util.List;
import java.util.Map;
import java.util.Set;

import io.split.android.client.SplitClient;
import io.split.android.client.SplitFactory;
import io.split.android.client.SplitResult;
import io.split.android.client.api.Key;
import io.split.android.client.utils.ConcurrentSet;

class SplitWrapperImpl implements SplitWrapper {

    private final SplitFactory mSplitFactory;
    private final Set<Key> mUsedKeys;

    SplitWrapperImpl(@NonNull SplitFactoryProvider splitFactoryProvider) {
        this(splitFactoryProvider, new ConcurrentSet<>());
    }

    @VisibleForTesting
    SplitWrapperImpl(@NonNull SplitFactoryProvider splitFactoryProvider, Set<Key> usedKeys) {
        mSplitFactory = splitFactoryProvider.getSplitFactory();
        mUsedKeys = usedKeys;
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

    @Override
    public boolean setAttribute(String matchingKey, @Nullable String bucketingKey, String attributeName, Object value) {
        return getClient(matchingKey, bucketingKey).setAttribute(attributeName, value);
    }

    @Nullable
    @Override
    public Object getAttribute(String matchingKey, @Nullable String bucketingKey, String attributeName) {
        return getClient(matchingKey, bucketingKey).getAttribute(attributeName);
    }

    @Override
    public boolean setAttributes(String matchingKey, @Nullable String bucketingKey, Map<String, Object> attributes) {
        return getClient(matchingKey, bucketingKey).setAttributes(attributes);
    }

    @NonNull
    @Override
    public Map<String, Object> getAllAttributes(String matchingKey, @Nullable String bucketingKey) {
        return getClient(matchingKey, bucketingKey).getAllAttributes();
    }

    @Override
    public boolean removeAttribute(String matchingKey, @Nullable String bucketingKey, String attributeName) {
        return getClient(matchingKey, bucketingKey).removeAttribute(attributeName);
    }

    @Override
    public boolean clearAttributes(String matchingKey, @Nullable String bucketingKey) {
        return getClient(matchingKey, bucketingKey).clearAttributes();
    }

    @Override
    public void flush(String matchingKey, @Nullable String bucketingKey) {
        Key requestedKey = new Key(matchingKey, bucketingKey);
        if (mUsedKeys.contains(requestedKey)) {
            getClient(matchingKey, bucketingKey).flush();
        }
    }

    @Override
    public void destroy(String matchingKey, @Nullable String bucketingKey) {
        Key requestedKey = new Key(matchingKey, bucketingKey);
        if (mUsedKeys.contains(requestedKey)) {
            getClient(matchingKey, bucketingKey).destroy();

            mUsedKeys.remove(requestedKey);
        }
    }
}
