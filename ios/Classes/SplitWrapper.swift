import Foundation
import Split

protocol SplitWrapper: EvaluationWrapper, AttributesWrapper {

    func getClient(matchingKey: String, bucketingKey: String?) -> SplitClient?

    func track(matchingKey: String, bucketingKey: String?, eventType: String, trafficType: String?, value: Double?, properties: [String: Any]) -> Bool

    func destroy()
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

    init(splitFactoryProvider: SplitFactoryProvider) {
        splitFactory = splitFactoryProvider.getFactory()
        usedKeys = Set()
    }

    func getClient(matchingKey: String, bucketingKey: String? = nil) -> SplitClient? {
        let key = Key(matchingKey: matchingKey, bucketingKey: bucketingKey)
        guard let client = splitFactory?.client(key: key) else {
            print("Client couldn't be created")
            return nil
        }

        usedKeys.insert(key)

        return client
    }

    func getTreatment(matchingKey: String, splitName: String, bucketingKey: String? = nil, attributes: [String: Any]? = [:]) -> String? {
        guard let client = getClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return nil
        }

        return client.getTreatment(splitName, attributes: attributes)
    }

    func getTreatments(matchingKey: String, splits: [String], bucketingKey: String? = nil, attributes: [String: Any]? = [:]) -> [String: String] {
        guard let client = getClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return [:]
        }

        return client.getTreatments(splits: splits, attributes: attributes)
    }

    func getTreatmentWithConfig(matchingKey: String, splitName: String, bucketingKey: String? = nil, attributes: [String: Any]? = [:]) -> SplitResult? {
        guard let client = getClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return nil
        }

        return client.getTreatmentWithConfig(splitName, attributes: attributes)
    }

    func getTreatmentsWithConfig(matchingKey: String, splits: [String], bucketingKey: String?, attributes: [String: Any]? = [:]) -> [String: SplitResult] {
        guard let client = getClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return [:]
        }

        return client.getTreatmentsWithConfig(splits: splits, attributes: attributes)
    }

    func track(matchingKey: String, bucketingKey: String?, eventType: String, trafficType: String?, value: Double?, properties: [String: Any]) -> Bool {
        guard let client = getClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
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
        guard let client = getClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return false
        }

        return client.setAttribute(name: attributeName, value: value)
    }

    func getAttribute(matchingKey: String, bucketingKey: String?, attributeName: String) -> Any? {
        guard let client = getClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return nil
        }

        return client.getAttribute(name: attributeName)
    }

    func setAttributes(matchingKey: String, bucketingKey: String?, attributes: [String: Any?]) -> Bool {
        guard let client = getClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return false
        }

        return client.setAttributes(attributes)
    }

    func getAllAttributes(matchingKey: String, bucketingKey: String?) -> [String: Any] {
        guard let client = getClient(matchingKey: matchingKey, bucketingKey: bucketingKey) else {
            return [:]
        }

        return client.getAttributes() ?? [:]
    }

    func removeAttribute(matchingKey: String, bucketingKey: String?, attributeName: String) -> Bool {
        return true // TODO
    }

    func clearAttributes(matchingKey: String, bucketingKey: String?) -> Bool {
        return true // TODO
    }

    func destroy() {
        usedKeys.forEach { usedKey in
            if let client = splitFactory?.client(key: usedKey) {
                usedKeys.remove(usedKey)
                client.destroy()
            }
        }
    }
}
