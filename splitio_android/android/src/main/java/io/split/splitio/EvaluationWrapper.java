package io.split.splitio;

import java.util.List;
import java.util.Map;

import io.split.android.client.EvaluationOptions;
import io.split.android.client.SplitResult;

interface EvaluationWrapper {
    String getTreatment(String matchingKey, String bucketingKey, String splitName, Map<String, Object> attributes, EvaluationOptions evaluationOptions);

    Map<String, String> getTreatments(String matchingKey, String bucketingKey, List<String> splitNames, Map<String, Object> attributes, EvaluationOptions evaluationOptions);

    SplitResult getTreatmentWithConfig(String matchingKey, String bucketingKey, String splitName, Map<String, Object> attributes, EvaluationOptions evaluationOptions);

    Map<String, SplitResult> getTreatmentsWithConfig(String matchingKey, String bucketingKey, List<String> splitNames, Map<String, Object> attributes, EvaluationOptions evaluationOptions);

    Map<String, String> getTreatmentsByFlagSet(String matchingKey, String bucketingKey, String flagSet, Map<String, Object> attributes, EvaluationOptions evaluationOptions);

    Map<String, String> getTreatmentsByFlagSets(String matchingKey, String bucketingKey, List<String> flagSets, Map<String, Object> attributes, EvaluationOptions evaluationOptions);

    Map<String, SplitResult> getTreatmentsWithConfigByFlagSet(String matchingKey, String bucketingKey, String flagSet, Map<String, Object> attributes, EvaluationOptions evaluationOptions);

    Map<String, SplitResult> getTreatmentsWithConfigByFlagSets(String matchingKey, String bucketingKey, List<String> flagSets, Map<String, Object> attributes, EvaluationOptions evaluationOptions);
}
