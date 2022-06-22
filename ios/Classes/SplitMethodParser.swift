import Foundation
import Split

protocol SplitMethodParser {
    
    func onMethodCall(methodName: String, arguments: Any, result: FlutterResult)
}

class DefaultSplitMethodParser : SplitMethodParser {
    
    private var splitWrapper: SplitWrapper?
    private let argumentParser: ArgumentParser
    private var methodChannel: FlutterMethodChannel
    
    init(methodChannel: FlutterMethodChannel) {
        self.argumentParser = DefaultArgumentParser()
        self.methodChannel = methodChannel
    }

    init(splitWrapper: SplitWrapper, argumentParser: ArgumentParser, methodChannel: FlutterMethodChannel) {
        self.splitWrapper = splitWrapper
        self.argumentParser = argumentParser
        self.methodChannel = methodChannel
    }

    func onMethodCall(methodName: String, arguments: Any, result: FlutterResult) {
        switch (methodName) {
            case Constants.Methods.METHOD_INIT:
                initializeSplit(
                    apiKey: argumentParser.getStringArgument(argumentName: Constants.Arguments.ARG_API_KEY, arguments: arguments) ?? "",
                    matchingKey: argumentParser.getStringArgument(argumentName: Constants.Arguments.ARG_MATCHING_KEY, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: Constants.Arguments.ARG_BUCKETING_KEY, arguments: arguments),
                    configurationMap: argumentParser.getMapArgument(argumentName: Constants.Arguments.ARG_CONFIG, arguments: arguments),
                    result: result
                )
                break
            case Constants.Methods.METHOD_GET_CLIENT:
                getClient(
                    matchingKey: argumentParser.getStringArgument(argumentName: Constants.Arguments.ARG_MATCHING_KEY, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: Constants.Arguments.ARG_BUCKETING_KEY, arguments: arguments),
                    waitForReady: argumentParser.getBooleanArgument(argumentName: Constants.Arguments.ARG_WAIT_FOR_READY, arguments: arguments),
                    result: result);
                break;
            case Constants.Methods.METHOD_DESTROY:
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
        splitWrapper?.getClient(matchingKey: matchingKey, bucketingKey: bucketingKey, waitForReady: waitForReady, methodChannel: self.methodChannel)
        result(nil)
    }
}
