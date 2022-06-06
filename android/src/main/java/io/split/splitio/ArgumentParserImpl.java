package io.split.splitio;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.Map;

class ArgumentParserImpl implements ArgumentParser {

    @Nullable
    @Override
    public String getStringArgument(@NonNull String argumentName, @NonNull Object arguments) {
        try {
            Map<String, Object> argMap = (Map<String, Object>) arguments;
            return (String) argMap.get(argumentName);
        } catch (ClassCastException exception) {
            return null;
        }
    }

    @NonNull
    @Override
    public Map<String, Object> getMapArgument(@NonNull String argumentName, @NonNull Object arguments) {
        try {
            Map<String, Object> argMap = (Map<String, Object>) arguments;
            return (argMap.get(argumentName) == null) ? new HashMap<>() : (Map<String, Object>) argMap.get(argumentName);
        } catch (ClassCastException exception) {
            return new HashMap<>();
        }
    }

    @Override
    public boolean getBooleanArgument(@NonNull String argumentName, @NonNull Object arguments) {
        try {
            Map<String, Object> argMap = (Map<String, Object>) arguments;
            return (argMap.get(argumentName) == null) ? false : (boolean) argMap.get(argumentName);
        } catch (ClassCastException exception) {
            return false;
        }
    }
}
