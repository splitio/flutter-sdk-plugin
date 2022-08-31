package io.split.splitio;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.split.android.client.api.Key;

public class Helper {

    @NonNull
    static Key buildKey(String matchingKey, @Nullable String bucketingKey) {
        if (bucketingKey != null && !bucketingKey.isEmpty()) {
            return new Key(matchingKey, bucketingKey);
        }

        return new Key(matchingKey);
    }
}
