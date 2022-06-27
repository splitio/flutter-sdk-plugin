import Foundation
import Split

protocol SplitMethodParser {

    func onMethodCall(methodName: String, arguments: Any, result: FlutterResult)
}

class DefaultSplitMethodParser: SplitMethodParser {

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
        guard let method = Method(rawValue: methodName) else {
            result(FlutterMethodNotImplemented)
            return
        }
        switch method {
            case .initialize:
                initializeSplit(
                    apiKey: argumentParser.getStringArgument(argumentName: Argument.apiKey, arguments: arguments) ?? "",
                    matchingKey: argumentParser.getStringArgument(argumentName: Argument.matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: Argument.bucketingKey, arguments: arguments),
                    configurationMap: argumentParser.getMapArgument(argumentName: Argument.config, arguments: arguments),
                    result: result
                )
                break
            case .client:
                getClient(
                    matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                    waitForReady: argumentParser.getBooleanArgument(argumentName: .waitForReady, arguments: arguments),
                    result: result)
                break
            case .getTreatment:
                getTreatment(
                    matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                    splitName: argumentParser.getStringArgument(argumentName: .splitName, arguments: arguments) ?? "",
                    attributes: argumentParser.getMapArgument(argumentName: .attributes, arguments: arguments) as [String: Any],
                    result: result)
                break
            case .getTreatments:
                getTreatments(
                    matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                    splits: argumentParser.getStringListArgument(argumentName: .splitName, arguments: arguments),
                    attributes: argumentParser.getMapArgument(argumentName: .attributes, arguments: arguments) as [String: Any],
                    result: result)
                break
            case .getTreatmentWithConfig:
                getTreatment(
                    matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                    splitName: argumentParser.getStringArgument(argumentName: .splitName, arguments: arguments) ?? "",
                    attributes: argumentParser.getMapArgument(argumentName: .attributes, arguments: arguments) as [String: Any],
                    result: result)
                break
            case .getTreatmentsWithConfig:
                getTreatments(
                    matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                    splits: argumentParser.getStringListArgument(argumentName: .splitName, arguments: arguments),
                    attributes: argumentParser.getMapArgument(argumentName: .attributes, arguments: arguments) as [String: Any],
                    result: result)
                break
            case .destroy:
                splitWrapper?.destroy()
                result(nil)
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
        guard let splitWrapper = getSplitWrapper() else {
            result(nil)
            return
        }

        if let client = splitWrapper.getClient(matchingKey: matchingKey, bucketingKey: bucketingKey) {
            addEventListeners(client: client, matchingKey: matchingKey, bucketingKey: bucketingKey, methodChannel: self.methodChannel, waitForReady: waitForReady)
        }
        result(nil)
    }

    private func getTreatment(matchingKey: String, bucketingKey: String? = nil, splitName: String, attributes: [String: Any]? = [:], result: FlutterResult) {
        guard let splitWrapper = getSplitWrapper() else {
            result(nil)
            return
        }

        result(splitWrapper.getTreatment(matchingKey: matchingKey, splitName: splitName, bucketingKey: bucketingKey, attributes: attributes))
    }

    private func getTreatments(matchingKey: String, bucketingKey: String? = nil, splits: [String], attributes: [String: Any]? = [:], result: FlutterResult) {
        guard let splitWrapper = getSplitWrapper() else {
            result(nil)
            return
        }

        result(splitWrapper.getTreatments(matchingKey: matchingKey, splits: splits, bucketingKey: bucketingKey, attributes: attributes))
    }

    private func getTreatmentWithConfig(matchingKey: String, bucketingKey: String? = nil, splitName: String, attributes: [String: Any]? = [:], result: FlutterResult) {
        guard let splitWrapper = getSplitWrapper() else {
            result(nil)
            return
        }

        guard let treatment = splitWrapper.getTreatmentWithConfig(matchingKey: matchingKey, splitName: splitName, bucketingKey: bucketingKey, attributes: attributes) else {
            result(nil)
            return
        }

        result([splitName: ["treatment": treatment.treatment, "config": treatment.config]])
    }

    private func getTreatmentsWithConfig(matchingKey: String, bucketingKey: String? = nil, splits: [String], attributes: [String: Any]? = [:], result: FlutterResult) {
        guard let splitWrapper = getSplitWrapper() else {
            result(nil)
            return
        }

        let treatments = splitWrapper.getTreatmentsWithConfig(matchingKey: matchingKey, splits: splits, bucketingKey: bucketingKey, attributes: attributes)

        result(treatments.mapValues {
            ["treatment": $0.treatment, "config": $0.config]
        })
    }

    private func addEventListeners(client: SplitClient?, matchingKey: String, bucketingKey: String?, methodChannel: FlutterMethodChannel, waitForReady: Bool) {
        if waitForReady {
            client?.on(event: SplitEvent.sdkReady) {
                self.invokeCallback(methodChannel: methodChannel, matchingKey: matchingKey, bucketingKey: bucketingKey)
            }
        } else {
            client?.on(event: SplitEvent.sdkReadyFromCache) {
                self.invokeCallback(methodChannel: methodChannel, matchingKey: matchingKey, bucketingKey: bucketingKey)
            }
        }

        client?.on(event: SplitEvent.sdkReadyTimedOut) {
            self.invokeCallback(methodChannel: methodChannel, matchingKey: matchingKey, bucketingKey: bucketingKey)
        }
    }

    private func invokeCallback(methodChannel: FlutterMethodChannel, matchingKey: String, bucketingKey: String?) {
        var args = [String: String]()
        args[Argument.matchingKey.rawValue] = matchingKey

        if let bucketing = bucketingKey {
            args[Argument.bucketingKey.rawValue] = bucketing
        }

        methodChannel.invokeMethod(Method.clientReady.rawValue, arguments: args)
    }

    private func getSplitWrapper() -> SplitWrapper? {
        guard let splitWrapper = splitWrapper else {
            print("Init needs to be called before getClient")
            return nil
        }

        return splitWrapper
    }
}
