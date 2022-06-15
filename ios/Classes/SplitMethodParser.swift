import Foundation
import Split

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
    
    init() {
        argumentParser = DefaultArgumentParser()
    }

    init(splitWrapper: SplitWrapper, argumentParser: ArgumentParser) {
        self.splitWrapper = splitWrapper
        self.argumentParser = argumentParser
    }

    func onMethodCall(methodName: String, arguments: Any, result: FlutterResult) {
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
            case METHOD_GET_CLIENT:
                getClient(
                    matchingKey: argumentParser.getStringArgument(argumentName: ARG_MATCHING_KEY, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: ARG_BUCKETING_KEY, arguments: arguments),
                    waitForReady: argumentParser.getBooleanArgument(argumentName: ARG_WAIT_FOR_READY, arguments: arguments),
                    result: result);
                break;
            case METHOD_DESTROY:
                splitWrapper?.destroy();
                result(nil);
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    private func initializeSplit(apiKey: String, matchingKey: String, bucketingKey: String?, configurationMap: [String: Any?], result: FlutterResult) {
        let factoryProvider = DefaultSplitFactoryProvider(
            apiKey: apiKey,
            matchingKey: matchingKey,
            bucketingKey: bucketingKey,
            splitClientConfig: SplitClientConfigHelper.fromMap(configurationMap: configurationMap))
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: factoryProvider)

        result(nil)
    }

    private func getClient(matchingKey: String, bucketingKey: String?, waitForReady: Bool = false, result: FlutterResult) {
        splitWrapper?.getClient(matchingKey: matchingKey, bucketingKey: bucketingKey, waitForReady: waitForReady)
        result(nil)
    }
}
