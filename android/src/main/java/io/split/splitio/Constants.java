package io.split.splitio;

class Constants {

    static class Method {
        static final String METHOD_INIT = "init";
        static final String METHOD_GET_CLIENT = "getClient";
        static final String METHOD_DESTROY = "destroy";
        static final String METHOD_CLIENT_READY = "clientReady";
    }

    static class Argument {
        static final String ARG_API_KEY = "apiKey";
        static final String ARG_MATCHING_KEY = "matchingKey";
        static final String ARG_BUCKETING_KEY = "bucketingKey";
        static final String ARG_CONFIG = "sdkConfiguration";
        static final String ARG_WAIT_FOR_READY = "waitForReady";
    }

    static class Error {
        static final String ERROR_SDK_NOT_INITIALIZED = "SDK_NOT_INITIALIZED";
        static final String ERROR_SDK_NOT_INITIALIZED_MESSAGE = "Split SDK has not been initialized";
    }
}
