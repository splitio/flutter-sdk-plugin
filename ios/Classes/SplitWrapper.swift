import Foundation
import Split

protocol SplitWrapper {

    func getClient(matchingKey: String, bucketingKey: String?) -> SplitClient?

    func getTreatment(matchingKey: String, splitName: String, bucketingKey: String?, attributes: [String: Any]?) -> String?

    func getTreatments(matchingKey: String, splits: [String], bucketingKey: String?, attributes: [String: Any]?) -> [String: String]

    func getTreatmentWithConfig(matchingKey: String, splitName: String, bucketingKey: String?, attributes: [String: Any]?) -> SplitResult?

    func getTreatmentsWithConfig(matchingKey: String, splits: [String], bucketingKey: String?, attributes: [String: Any]?) -> [String: SplitResult]

    func destroy()
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

    func destroy() {
        usedKeys.forEach { usedKey in
            if let client = splitFactory?.client(key: usedKey) {
                usedKeys.remove(usedKey)
                client.destroy()
            }
        }
    }
}
