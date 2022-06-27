package io.split.splitio;

import androidx.annotation.Nullable;

import io.split.android.client.SplitClient;

interface SplitWrapper extends EvaluationWrapper {

    SplitClient getClient(String matchingKey, @Nullable String bucketingKey);

    void destroy();
}
