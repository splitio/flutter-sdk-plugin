import Foundation
import Split
import UIKit

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
                    apiKey: argumentParser.getStringArgument(argumentName: .apiKey, arguments: arguments) ?? "",
                    matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                    configurationMap: argumentParser.getMapArgument(argumentName: .config, arguments: arguments))
                result(nil)
                break
            case .client:
                getClient(
                    matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments))
                result(nil)
                break
            case .getTreatment:
                result(getTreatment(
                    matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                    splitName: argumentParser.getStringArgument(argumentName: .splitName, arguments: arguments) ?? "",
                    attributes: argumentParser.getMapArgument(argumentName: .attributes, arguments: arguments) as [String: Any]))
                break
            case .getTreatments:
                result(getTreatments(
                    matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                    splits: argumentParser.getStringListArgument(argumentName: .splitName, arguments: arguments),
                    attributes: argumentParser.getMapArgument(argumentName: .attributes, arguments: arguments) as [String: Any]))
                break
            case .getTreatmentWithConfig:
                result(getTreatmentWithConfig(
                    matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                    splitName: argumentParser.getStringArgument(argumentName: .splitName, arguments: arguments) ?? "",
                    attributes: argumentParser.getMapArgument(argumentName: .attributes, arguments: arguments) as [String: Any]))
                break
            case .getTreatmentsWithConfig:
                result(getTreatmentsWithConfig(
                    matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                    bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                    splits: argumentParser.getStringListArgument(argumentName: .splitName, arguments: arguments),
                    attributes: argumentParser.getMapArgument(argumentName: .attributes, arguments: arguments) as [String: Any]))
                break
            case .track:
                result(track(matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                      bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                      eventType: argumentParser.getStringArgument(argumentName: .eventType, arguments: arguments) ?? "",
                      trafficType: argumentParser.getStringArgument(argumentName: .trafficType, arguments: arguments),
                      value: argumentParser.getDoubleArgument(argumentName: .value, arguments: arguments),
                      properties: argumentParser.getMapArgument(argumentName: .properties, arguments: arguments)))
                break
            case .getAttribute:
                result(getAttribute(matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                             bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                             attributeName: argumentParser.getStringArgument(argumentName: .attributeName, arguments: arguments)))
                break
             case .getAllAttributes:
                result(getAllAttributes(matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                         bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments)))
                break
            case .setAttribute:
                result(setAttribute(matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                         bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                         attributeName: argumentParser.getStringArgument(argumentName: .attributeName, arguments: arguments),
                         attributeValue: argumentParser.getAnyArgument(argumentName: .value, arguments: arguments)))
                break
            case .setAttributes:
                result(setAttributes(matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                     bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                     attributes: argumentParser.getMapArgument(argumentName: .attributes, arguments: arguments)))
                break
            case .removeAttribute:
                result(removeAttribute(matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                                   bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments),
                                   attributeName: argumentParser.getStringArgument(argumentName: .attributeName, arguments: arguments)))
                break
            case .clearAttributes:
                result(clearAttributes(matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                               bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments)))
                break
            case .flush:
                splitWrapper?.flush(matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                              bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments))
                result(nil)
                break
            case .destroy:
                splitWrapper?.destroy(matchingKey: argumentParser.getStringArgument(argumentName: .matchingKey, arguments: arguments) ?? "",
                              bucketingKey: argumentParser.getStringArgument(argumentName: .bucketingKey, arguments: arguments))
                result(nil)
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    private func initializeSplit(apiKey: String, matchingKey: String, bucketingKey: String?, configurationMap: [String: Any?]) {
        let factoryProvider = DefaultSplitFactoryProvider(
            apiKey: apiKey,
            matchingKey: matchingKey,
            bucketingKey: bucketingKey,
            splitClientConfig: SplitClientConfigHelper.fromMap(configurationMap: configurationMap))
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: factoryProvider)
    }

    private func getClient(matchingKey: String, bucketingKey: String?) {
        guard let splitWrapper = getSplitWrapper() else {
            return
        }

        if let client = splitWrapper.getClient(matchingKey: matchingKey, bucketingKey: bucketingKey) {
            addEventListeners(client: client, matchingKey: matchingKey, bucketingKey: bucketingKey, methodChannel: self.methodChannel)
        }
    }

    private func getTreatment(matchingKey: String, bucketingKey: String? = nil, splitName: String, attributes: [String: Any]? = [:]) -> String? {
        guard let splitWrapper = getSplitWrapper() else {
            return nil
        }

        return splitWrapper.getTreatment(matchingKey: matchingKey, splitName: splitName, bucketingKey: bucketingKey, attributes: attributes)
    }

    private func getTreatments(matchingKey: String, bucketingKey: String? = nil, splits: [String], attributes: [String: Any]? = [:]) -> [String: String] {
        guard let splitWrapper = getSplitWrapper() else {
            return [:]
        }

        return splitWrapper.getTreatments(matchingKey: matchingKey, splits: splits, bucketingKey: bucketingKey, attributes: attributes)
    }

    private func getTreatmentWithConfig(matchingKey: String, bucketingKey: String? = nil, splitName: String, attributes: [String: Any]? = [:]) -> [String: [String: String?]] {
        guard let splitWrapper = getSplitWrapper() else {
            return [:]
        }

        guard let treatment = splitWrapper.getTreatmentWithConfig(matchingKey: matchingKey, splitName: splitName, bucketingKey: bucketingKey, attributes: attributes) else {
            return [:]
        }

        return [splitName: ["treatment": treatment.treatment, "config": treatment.config]]
    }

    private func getTreatmentsWithConfig(matchingKey: String, bucketingKey: String? = nil, splits: [String], attributes: [String: Any]? = [:]) -> [String: [String: String?]] {
        guard let splitWrapper = getSplitWrapper() else {
            return [:]
        }

        let treatments = splitWrapper.getTreatmentsWithConfig(matchingKey: matchingKey, splits: splits, bucketingKey: bucketingKey, attributes: attributes)

        return treatments.mapValues {
            ["treatment": $0.treatment, "config": $0.config]
        }
    }

    private func track(matchingKey: String, bucketingKey: String? = nil, eventType: String, trafficType: String? = nil, value: Double? = nil, properties: [String: Any?]) -> Bool {
        guard let splitWrapper = getSplitWrapper() else {
            return false
        }

        return splitWrapper.track(matchingKey: matchingKey, bucketingKey: bucketingKey, eventType: eventType, trafficType: trafficType, value: value, properties: properties)
    }

    private func getAttribute(matchingKey: String, bucketingKey: String?, attributeName: String?) -> Any? {
        guard let attributeName = attributeName else {
            return nil
        }

        guard let splitWrapper = getSplitWrapper() else {
            return nil
        }

        return splitWrapper.getAttribute(matchingKey: matchingKey, bucketingKey: bucketingKey, attributeName: attributeName)
    }

    private func getAllAttributes(matchingKey: String, bucketingKey: String?) -> [String: Any] {
        guard let splitWrapper = getSplitWrapper() else {
            return [:]
        }

        return splitWrapper.getAllAttributes(matchingKey: matchingKey, bucketingKey: bucketingKey)
    }

    private func setAttribute(matchingKey: String, bucketingKey: String?, attributeName: String?, attributeValue: Any?) -> Bool {
        guard let attributeName = attributeName else {
            return false
        }

        guard let splitWrapper = getSplitWrapper() else {
            return false
        }

        return splitWrapper.setAttribute(matchingKey: matchingKey, bucketingKey: bucketingKey, attributeName: attributeName, value: attributeValue)
    }

    private func setAttributes(matchingKey: String, bucketingKey: String?, attributes: [String: Any?]) -> Bool {
        guard let splitWrapper = getSplitWrapper() else {
            return false
        }

        return splitWrapper.setAttributes(matchingKey: matchingKey, bucketingKey: bucketingKey, attributes: attributes)
    }

    private func removeAttribute(matchingKey: String, bucketingKey: String?, attributeName: String?) -> Bool {
        guard let attributeName = attributeName else {
            return false
        }

        guard let splitWrapper = getSplitWrapper() else {
            return false
        }

        return splitWrapper.removeAttribute(matchingKey: matchingKey, bucketingKey: bucketingKey, attributeName: attributeName)
    }

    private func clearAttributes(matchingKey: String, bucketingKey: String?) -> Bool {
        guard let splitWrapper = getSplitWrapper() else {
            return false
        }

        return splitWrapper.clearAttributes(matchingKey: matchingKey, bucketingKey: bucketingKey)
    }

    private func addEventListeners(client: SplitClient?, matchingKey: String, bucketingKey: String?, methodChannel: FlutterMethodChannel) {
        client?.on(event: SplitEvent.sdkReady) {
            self.invokeCallback(methodChannel: methodChannel, matchingKey: matchingKey, bucketingKey: bucketingKey, method: .clientReady)
        }

        client?.on(event: SplitEvent.sdkReadyFromCache) {
            self.invokeCallback(methodChannel: methodChannel, matchingKey: matchingKey, bucketingKey: bucketingKey, method: .clientReadyFromCache)
        }

        client?.on(event: SplitEvent.sdkReadyTimedOut) {
            self.invokeCallback(methodChannel: methodChannel, matchingKey: matchingKey, bucketingKey: bucketingKey, method: .clientTimeout)
        }

        client?.on(event: SplitEvent.sdkUpdated) {
            self.invokeCallback(methodChannel: methodChannel, matchingKey: matchingKey, bucketingKey: bucketingKey, method: .clientUpdated)
        }
    }

    private func invokeCallback(methodChannel: FlutterMethodChannel, matchingKey: String, bucketingKey: String?, method: Method) {
        var args = [String: String]()
        args[Argument.matchingKey.rawValue] = matchingKey

        if let bucketing = bucketingKey {
            args[Argument.bucketingKey.rawValue] = bucketing
        }

        methodChannel.invokeMethod(method.rawValue, arguments: args)
    }

    private func getSplitWrapper() -> SplitWrapper? {
        guard let splitWrapper = splitWrapper else {
            print("Init needs to be called before getClient")
            return nil
        }

        return splitWrapper
    }
}
