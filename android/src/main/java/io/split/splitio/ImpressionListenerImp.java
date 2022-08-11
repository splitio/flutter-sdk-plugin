package io.split.splitio;

import static io.split.splitio.Constants.Method.IMPRESSION_LOG;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.split.android.client.impressions.Impression;
import io.split.android.client.impressions.ImpressionListener;
import io.split.android.client.utils.logger.Logger;

class ImpressionListenerImp implements ImpressionListener {

    private final MethodChannel mMethodChannel;

    ImpressionListenerImp(@NonNull MethodChannel methodChannel) {
        mMethodChannel = methodChannel;
    }

    @Override
    public void log(Impression impression) {
        try {
            mMethodChannel.invokeMethod(IMPRESSION_LOG, impressionToMap(impression));
        } catch (Exception exception) {
            Logger.i("Failed to return impression log");
        }
    }

    @Override
    public void close() {

    }

    private Map<String, Object> impressionToMap(final Impression impression) {
        final Map<String, Object> impressionMap = new HashMap<>();

        impressionMap.put("key", impression.key());
        impressionMap.put("bucketingKey", impression.bucketingKey());
        impressionMap.put("split", impression.split());
        impressionMap.put("treatment", impression.treatment());
        impressionMap.put("time", impression.time());
        impressionMap.put("appliedRule", impression.appliedRule());
        impressionMap.put("changeNumber", impression.changeNumber());
        impressionMap.put("attributes", impression.attributes());

        return impressionMap;
    }
}
