import Foundation
import Split

protocol SplitWrapper: EvaluationWrapper, AttributesWrapper {

    func getClient(matchingKey: String, bucketingKey: String?) -> SplitClient?

    func track(matchingKey: String, bucketingKey: String?, eventType: String, trafficType: String?, value: Double?, properties: [String: Any]) -> Bool

    func flush(matchingKey: String, bucketingKey: String?)

    func destroy(matchingKey: String, bucketingKey: String?)

    func splitNames() -> [String]

    func splits() -> [SplitView]

    func split(splitName: String) -> SplitView?
}

protocol EvaluationWrapper {

    func getTreatment(matchingKey: String, splitName: String, bucketingKey: String?, attributes: [String: Any]?) -> String?

    func getTreatments(matchingKey: String, splits: [String], bucketingKey: String?, attributes: [String: Any]?) -> [String: String]

    func getTreatmentWithConfig(matchingKey: String, splitName: String, bucketingKey: String?, attributes: [String: Any]?) -> SplitResult?

    func getTreatmentsWithConfig(matchingKey: String, splits: [String], bucketingKey: String?, attributes: [String: Any]?) -> [String: SplitResult]
}

protocol AttributesWrapper {

    func setAttribute(matchingKey: String, bucketingKey: String?, attributeName: String, value: Any?) -> Bool

    func getAttribute(matchingKey: String, bucketingKey: String?, attributeName: String) -> Any?

    func setAttributes(matchingKey: String, bucketingKey: String?, attributes: [String: Any?]) -> Bool

    func getAllAttributes(matchingKey: String, bucketingKey: String?) -> [String: Any]

    func removeAttribute(matchingKey: String, bucketingKey: String?, attributeName: String) -> Bool

    func clearAttributes(matchingKey: String, bucketingKey: String?) -> Bool
}

class DefaultSplitWrapper: SplitWrapper {

    private let splitFactory: SplitFactory?
    private var usedKeys: Set<Key>

    convenience init(splitFactoryProvider: SplitFactoryProvider) {
        self.init(splitFactoryProvider: splitFactoryProvider, usedKeys: Set())
    }

    init(splitFactoryProvider: SplitFactoryProvider, usedKeys: Set<Key>) {
        self.splitFactory = splitFactoryProvider.getFactory()
        self.usedKeys = usedKeys
    }

    func getClient(matchingKey: String, bucketingKey: String? = nil) -> SplitClient? {
        let key = Key(matchingKey: matchingKey, bucketingKey: bucketingKey)
        guard let client = splitFactory?.client(key: key) else {
            print("Split Client couldn't be created")
            return nil
        }

        usedKeys.insert(key)

        return client
    }

    private func getInitializedClient(matchingKey: String, bucketingKey: String? = nil) -> SplitClient? {
        let key = Key(matchingKey: matchingKey, bucketingKey: bucketingKey)
        if usedKeys.contains(key) {
            return splitFactory?.client(key: key)
        } else {
            print("Split Client has not been initialized")
            return nil
        }
    }

    func getTreatment(matchingKey: String, splitName: String, bucketingKey: String? = nil, attributes: [String: Any]? = [:]) -> String? {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return "control"
        }

        return client.getTreatment(splitName, attributes: attributes)
    }

    func getTreatments(matchingKey: String, splits: [String], bucketingKey: String? = nil, attributes: [String: Any]? = [:]) -> [String: String] {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            var defaultResults: [String: String] = [:]
            splits.forEach {
                defaultResults[$0] = "control"
            }

            return defaultResults
        }

        return client.getTreatments(splits: splits, attributes: attributes)
    }

    func getTreatmentWithConfig(matchingKey: String, splitName: String, bucketingKey: String? = nil, attributes: [String: Any]? = [:]) -> SplitResult? {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return nil
        }

        return client.getTreatmentWithConfig(splitName, attributes: attributes)
    }

    func getTreatmentsWithConfig(matchingKey: String, splits: [String], bucketingKey: String?, attributes: [String: Any]? = [:]) -> [String: SplitResult] {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return [:]
        }

        return client.getTreatmentsWithConfig(splits: splits, attributes: attributes)
    }

    func track(matchingKey: String, bucketingKey: String?, eventType: String, trafficType: String?, value: Double?, properties: [String: Any]) -> Bool {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return false
        }

        guard let trafficType = trafficType else {
            guard let value = value else {
                return client.track(eventType: eventType, properties: properties)
            }

            return client.track(eventType: eventType, value: value, properties: properties)
        }

        guard let value = value else {
            return client.track(trafficType: trafficType, eventType: eventType, properties: properties)
        }

        return client.track(trafficType: trafficType, eventType: eventType, value: value, properties: properties)
    }

    func setAttribute(matchingKey: String, bucketingKey: String?, attributeName: String, value: Any?) -> Bool {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return false
        }

        return client.setAttribute(name: attributeName, value: value)
    }

    func getAttribute(matchingKey: String, bucketingKey: String?, attributeName: String) -> Any? {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return nil
        }

        return client.getAttribute(name: attributeName)
    }

    func setAttributes(matchingKey: String, bucketingKey: String?, attributes: [String: Any?]) -> Bool {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return false
        }

        return client.setAttributes(attributes)
    }

    func getAllAttributes(matchingKey: String, bucketingKey: String?) -> [String: Any] {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return [:]
        }

        return client.getAttributes() ?? [:]
    }

    func removeAttribute(matchingKey: String, bucketingKey: String?, attributeName: String) -> Bool {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return false
        }

        return client.removeAttribute(name: attributeName)
    }

    func clearAttributes(matchingKey: String, bucketingKey: String?) -> Bool {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return false
        }

        return client.clearAttributes()
    }

    func flush(matchingKey: String, bucketingKey: String?) {
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return
        }

        client.flush()
    }

    func destroy(matchingKey: String, bucketingKey: String?) {
        let requestedKey = Key(matchingKey: matchingKey, bucketingKey: bucketingKey)
        guard let client = getInitializedClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return
        }

        client.destroy()

        usedKeys.remove(requestedKey)
    }

    func splitNames() -> [String] {
        if let splitFactory = splitFactory {
            return splitFactory.manager.splitNames
        } else {
            return []
        }
    }

    func splits() -> [SplitView] {
        if let splitFactory = splitFactory {
            return splitFactory.manager.splits
        } else {
            return []
        }
    }

    func split(splitName: String) -> SplitView? {
        if let splitFactory = splitFactory {
            return splitFactory.manager.split(featureName: splitName)
        } else {
            return nil
        }
    }
}
