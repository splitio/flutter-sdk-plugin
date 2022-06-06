package io.split.splitio;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodChannel;

public interface SplitMethodParser {

    void onMethodCall(String methodName, Object arguments, @NonNull MethodChannel.Result result);
}
