package io.split.splitio;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.split.android.client.SplitClient;
import io.split.android.client.SplitFactory;
import io.split.android.client.SplitResult;
import io.split.android.client.api.Key;
import io.split.android.client.api.SplitView;
import io.split.android.client.shared.UserConsent;
import io.split.android.client.utils.ConcurrentSet;
import io.split.android.grammar.Treatments;

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

    @Nullable
    private SplitClient getInitializedClient(String matchingKey, @Nullable String bucketingKey) {
        Key key = Helper.buildKey(matchingKey, bucketingKey);
        if (mUsedKeys.contains(key)) {
            return mSplitFactory.client(matchingKey, bucketingKey);
        }

        return null;
    }

    @Override
    public boolean track(String matchingKey, @Nullable String bucketingKey, String eventType, @Nullable String trafficType, @Nullable Double value, Map<String, Object> properties) {
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);

        if (client == null) {
            return false;
        }

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
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client == null) {
            return Treatments.CONTROL;
        }

        return client.getTreatment(splitName, attributes);
    }

    @Override
    public Map<String, String> getTreatments(String matchingKey, String bucketingKey, List<String> splitNames, Map<String, Object> attributes) {
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client == null) {
            Map<String, String> defaultResult = new HashMap<>();
            for (String splitName: splitNames) {
                defaultResult.put(splitName, Treatments.CONTROL);
            }

            return defaultResult;
        }

        return client.getTreatments(splitNames, attributes);
    }

    @Override
    public SplitResult getTreatmentWithConfig(String matchingKey, String bucketingKey, String splitName, Map<String, Object> attributes) {
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client == null) {
            return new SplitResult(Treatments.CONTROL);
        }

        return client.getTreatmentWithConfig(splitName, attributes);
    }

    @Override
    public Map<String, SplitResult> getTreatmentsWithConfig(String matchingKey, String bucketingKey, List<String> splitNames, Map<String, Object> attributes) {
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client == null) {
            Map<String, SplitResult> defaultResult = new HashMap<>();
            for (String splitName: splitNames) {
                defaultResult.put(splitName, new SplitResult(Treatments.CONTROL));
            }

            return defaultResult;
        }

        return client.getTreatmentsWithConfig(splitNames, attributes);
    }

    @Override
    public boolean setAttribute(String matchingKey, @Nullable String bucketingKey, String attributeName, Object value) {
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client == null) {
            return false;
        }

        return client.setAttribute(attributeName, value);
    }

    @Nullable
    @Override
    public Object getAttribute(String matchingKey, @Nullable String bucketingKey, String attributeName) {
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client == null) {
            return null;
        }

        return client.getAttribute(attributeName);
    }

    @Override
    public boolean setAttributes(String matchingKey, @Nullable String bucketingKey, Map<String, Object> attributes) {
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client == null) {
            return false;
        }

        return client.setAttributes(attributes);
    }

    @NonNull
    @Override
    public Map<String, Object> getAllAttributes(String matchingKey, @Nullable String bucketingKey) {
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client == null) {
            return Collections.emptyMap();
        }

        return client.getAllAttributes();
    }

    @Override
    public boolean removeAttribute(String matchingKey, @Nullable String bucketingKey, String attributeName) {
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client == null) {
            return false;
        }

        return client.removeAttribute(attributeName);
    }

    @Override
    public boolean clearAttributes(String matchingKey, @Nullable String bucketingKey) {
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client == null) {
            return false;
        }

        return client.clearAttributes();
    }

    @Override
    public void flush(String matchingKey, @Nullable String bucketingKey) {
        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client != null) {
            client.flush();
        }
    }

    @Override
    public void destroy(String matchingKey, @Nullable String bucketingKey) {
        Key requestedKey = new Key(matchingKey, bucketingKey);

        SplitClient client = getInitializedClient(matchingKey, bucketingKey);
        if (client != null) {
            client.destroy();
            mUsedKeys.remove(requestedKey);
        }
    }

    @Override
    public List<String> splitNames() {
        return mSplitFactory.manager().splitNames();
    }

    @Override
    public List<SplitView> splits() {
        return mSplitFactory.manager().splits();
    }

    @Nullable
    @Override
    public SplitView split(String splitName) {
        return mSplitFactory.manager().split(splitName);
    }

    @Override
    public String getUserConsent() {
        UserConsent userConsent = mSplitFactory.getUserConsent();
        if (userConsent == UserConsent.GRANTED) {
            return "granted";
        } else if (userConsent == UserConsent.DECLINED) {
            return "declined";
        } else {
            return "unknown";
        }
    }

    @Override
    public void setUserConsent(boolean enabled) {
        mSplitFactory.setUserConsent(enabled);
    }
}
