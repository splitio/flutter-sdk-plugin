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
        static final String TRACK = "track";
        static final String GET_ATTRIBUTE = "getAttribute";
        static final String GET_ALL_ATTRIBUTES = "getAllAttributes";
        static final String SET_ATTRIBUTE = "setAttribute";
        static final String SET_ATTRIBUTES = "setAttributes";
        static final String REMOVE_ATTRIBUTE = "removeAttribute";
        static final String CLEAR_ATTRIBUTES = "clearAttributes";
    }

    static class Argument {
        static final String API_KEY = "apiKey";
        static final String MATCHING_KEY = "matchingKey";
        static final String BUCKETING_KEY = "bucketingKey";
        static final String SDK_CONFIGURATION = "sdkConfiguration";
        static final String WAIT_FOR_READY = "waitForReady";
        static final String SPLIT_NAME = "splitName";
        static final String ATTRIBUTES = "attributes";
        static final String EVENT_TYPE = "eventType";
        static final String TRAFFIC_TYPE = "trafficType";
        static final String VALUE = "value";
        static final String PROPERTIES = "properties";
        static final String ATTRIBUTE_NAME = "attributeName";
    }

    static class Error {
        static final String SDK_NOT_INITIALIZED = "SDK_NOT_INITIALIZED";
        static final String METHOD_PARSER_NOT_INITIALIZED = "METHOD_PARSER_NOT_INITIALIZED";
        static final String SDK_NOT_INITIALIZED_MESSAGE = "Split SDK has not been initialized";
    }
}
