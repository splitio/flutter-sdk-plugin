import Foundation

struct Constants {

    struct Methods {
        static let METHOD_INIT = "init"
        static let METHOD_GET_CLIENT = "getClient"
        static let METHOD_DESTROY = "destroy"
        static let METHOD_CLIENT_READY = "clientReady"
    }

    struct Arguments {
        static let ARG_API_KEY = "apiKey"
        static let ARG_MATCHING_KEY = "matchingKey"
        static let ARG_BUCKETING_KEY = "bucketingKey"
        static let ARG_CONFIG = "sdkConfiguration"
        static let ARG_WAIT_FOR_READY = "waitForReady"
    }
}
