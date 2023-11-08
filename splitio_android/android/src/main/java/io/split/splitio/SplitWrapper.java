package io.split.splitio;

import androidx.annotation.Nullable;

import java.util.List;
import java.util.Map;

import io.split.android.client.SplitClient;
import io.split.android.client.api.SplitView;

interface SplitWrapper extends EvaluationWrapper, AttributesWrapper {

    SplitClient getClient(String matchingKey, @Nullable String bucketingKey);

    boolean track(String matchingKey, @Nullable String bucketingKey, String eventType, @Nullable String trafficType, @Nullable Double value, Map<String, Object> properties);

    void flush(String matchingKey, @Nullable String bucketingKey);

    void destroy(String matchingKey, @Nullable String bucketingKey);

    List<String> splitNames();

    List<SplitView> splits();

    @Nullable
    SplitView split(String splitName);

    String getUserConsent();

    void setUserConsent(boolean enabled);
}
