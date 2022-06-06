package io.split.splitio;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.Map;

class ArgumentParserImpl implements ArgumentParser {

    @Nullable
    @Override
    public String getStringArgument(@NonNull String argumentName, @NonNull Object arguments) {
        Map<String, Object> argMap = (Map<String, Object>) arguments;
        return (String) argMap.get(argumentName);
    }

    @NonNull
    @Override
    public Map<String, Object> getMapArgument(@NonNull String argumentName, @NonNull Object arguments) {
        Map<String, Object> argMap = (Map<String, Object>) arguments;
        return (argMap.get(argumentName) == null) ? new HashMap<>() : (Map<String, Object>) argMap.get(argumentName);
    }

    @Override
    public boolean getBooleanArgument(@NonNull String argumentName, @NonNull Object arguments) {
        Map<String, Object> argMap = (Map<String, Object>) arguments;
        return (argMap.get(argumentName) == null) ? false : (boolean) argMap.get(argumentName);
    }
}
