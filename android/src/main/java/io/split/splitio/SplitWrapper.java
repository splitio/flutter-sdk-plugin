package io.split.splitio;

import androidx.annotation.Nullable;

import io.flutter.plugin.common.MethodChannel;
import io.split.android.client.SplitClient;

interface SplitWrapper {

    SplitClient getClient(String matchingKey, @Nullable String bucketingKey, boolean waitForReady);

    void destroy();
}
