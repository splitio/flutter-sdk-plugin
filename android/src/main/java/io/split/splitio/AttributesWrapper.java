package io.split.splitio;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

public interface AttributesWrapper {

    boolean setAttribute(String matchingKey, @Nullable String bucketingKey, String attributeName, Object value);

    @Nullable
    Object getAttribute(String matchingKey, @Nullable String bucketingKey, String attributeName);

    boolean setAttributes(String matchingKey, @Nullable String bucketingKey, Map<String, Object> attributes);

    @NonNull
    Map<String, Object> getAllAttributes(String matchingKey, @Nullable String bucketingKey);

    boolean removeAttribute(String matchingKey, @Nullable String bucketingKey, String attributeName);

    boolean clearAttributes(String matchingKey, @Nullable String bucketingKey);
}
