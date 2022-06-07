import Foundation

protocol SplitMethodParser {
    
    func onMethodCall(methodName: String, arguments: Any, result: FlutterResult)
}

class DefaultSplitMethodParser : SplitMethodParser {
    
    private var splitWrapper: SplitWrapper?
    private let argumentParser: ArgumentParser
    
    private let METHOD_INIT = "init";
    private let METHOD_GET_CLIENT = "getClient";
    private let METHOD_DESTROY = "destroy";

    private let ARG_API_KEY = "apiKey";
    private let ARG_MATCHING_KEY = "matchingKey";
    private let ARG_BUCKETING_KEY = "bucketingKey";
    private let ARG_CONFIG = "sdkConfiguration";
    private let ARG_WAIT_FOR_READY = "waitForReady";
    private let ERROR_SDK_NOT_INITIALIZED = "SDK_NOT_INITIALIZED";
    private let ERROR_SDK_NOT_INITIALIZED_MESSAGE = "Split SDK has not been initialized";
    
    init() {
        argumentParser = DefaultArgumentParser()
    }

    init(splitWrapper: SplitWrapper, argumentParser: ArgumentParser) {
        self.splitWrapper = splitWrapper
        self.argumentParser = argumentParser
    }

    func onMethodCall(methodName: String, arguments: Any, result: (Any?) -> Void) {
        switch (methodName) {
            case METHOD_INIT:
                initializeSplit(
                    apiKey: argumentParser.getStringArgument(argumentName: ARG_API_KEY, arguments: arguments) ?? "",
                    matchingKey: argumentParser.getStringArgument(argumentName: ARG_MATCHING_KEY, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: ARG_BUCKETING_KEY, arguments: arguments),
                    configurationMap: argumentParser.getMapArgument(argumentName: ARG_CONFIG, arguments: arguments),
                    result: result
                )
                break
            else:
                break
        }
    }
    
    private func initializeSplit(apiKey: String, matchingKey: String, bucketingKey: String?, configurationMap [String, Any?]?, result: FlutterResult) {
        splitWrapper = SplitWrapper(SplitFactoryProvider:
            SplitFactoryProvider(apiKey, matchingKey, bucketingKey, SplitClientConfigHelper.fromMap(mapArgument))
        )
    }
}
