package io.split.splitio;

import androidx.annotation.Nullable;

import java.util.Map;

import io.split.android.client.SplitClient;

interface SplitWrapper extends EvaluationWrapper, AttributesWrapper {

    SplitClient getClient(String matchingKey, @Nullable String bucketingKey);

    boolean track(String matchingKey, @Nullable String bucketingKey, String eventType, @Nullable String trafficType, @Nullable Double value, Map<String, Object> properties);

    void destroy();
}
