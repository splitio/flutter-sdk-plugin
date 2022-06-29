package io.split.splitio;

import androidx.annotation.NonNull;

import java.util.List;
import java.util.Map;

interface ArgumentParser {

    String getStringArgument(@NonNull String argumentName, @NonNull Object arguments);

    boolean getBooleanArgument(@NonNull String argumentName, @NonNull Object arguments);

    Map<String, Object> getMapArgument(@NonNull String argumentName, @NonNull Object arguments);

    List<String> getStringListArgument(@NonNull String argument, @NonNull Object arguments);

    Double getDoubleArgument(@NonNull String argument, @NonNull Object arguments);
}
