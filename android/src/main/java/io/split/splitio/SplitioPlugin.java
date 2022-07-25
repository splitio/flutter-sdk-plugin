package io.split.splitio;

import static io.split.splitio.Constants.Error.METHOD_PARSER_NOT_INITIALIZED;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.split.android.client.utils.logger.Logger;

/**
 * SplitioPlugin
 */
public class SplitioPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private SplitMethodParser methodParser;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "splitio");
        channel.setMethodCallHandler(this);
        methodParser = new SplitMethodParserImpl(flutterPluginBinding.getApplicationContext(), channel);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (methodParser != null) {
            methodParser.onMethodCall(call.method, call.arguments, result);
        } else {
            result.error(METHOD_PARSER_NOT_INITIALIZED, null, null);
            Logger.e("Method parser failed to initialize");
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        methodParser = null;
    }
}
