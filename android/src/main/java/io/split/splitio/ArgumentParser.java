package io.split.splitio;

import androidx.annotation.NonNull;

import java.util.Map;

public interface ArgumentParser {

    String getStringArgument(@NonNull String argumentName, @NonNull Object arguments);

    boolean getBooleanArgument(@NonNull String argumentName, @NonNull Object arguments);

    Map<String, Object> getMapArgument(@NonNull String argumentName, @NonNull Object arguments);
}
