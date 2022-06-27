package io.split.splitio;

class Constants {

    static class Method {
        static final String INIT = "init";
        static final String CLIENT = "getClient";
        static final String DESTROY = "destroy";
        static final String CLIENT_READY = "clientReady";
        static final String GET_TREATMENT = "getTreatment";
        static final String GET_TREATMENTS = "getTreatments";
        static final String GET_TREATMENT_WITH_CONFIG = "getTreatmentWithConfig";
        static final String GET_TREATMENTS_WITH_CONFIG = "getTreatmentsWithConfig";
    }

    static class Argument {
        static final String API_KEY = "apiKey";
        static final String MATCHING_KEY = "matchingKey";
        static final String BUCKETING_KEY = "bucketingKey";
        static final String SDK_CONFIGURATION = "sdkConfiguration";
        static final String WAIT_FOR_READY = "waitForReady";
        static final String SPLIT_NAME = "splitName";
        static final String ATTRIBUTES = "attributes";
    }

    static class Error {
        static final String SDK_NOT_INITIALIZED = "SDK_NOT_INITIALIZED";
        static final String METHOD_PARSER_NOT_INITIALIZED = "METHOD_PARSER_NOT_INITIALIZED";
        static final String SDK_NOT_INITIALIZED_MESSAGE = "Split SDK has not been initialized";
    }
}
