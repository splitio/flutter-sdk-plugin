import Foundation
import Split

protocol SplitWrapper {

    func getClient(matchingKey: String, bucketingKey: String?, waitForReady: Bool) -> SplitClient?

    func destroy()
}

class DefaultSplitWrapper : SplitWrapper {

    private let splitFactory: SplitFactory?
    private var usedKeys: Set<Key>

    init(splitFactoryProvider: SplitFactoryProvider) {
        splitFactory = splitFactoryProvider.getFactory()
        usedKeys = Set()
    }

    func getClient(matchingKey: String, bucketingKey: String? = nil, waitForReady: Bool = false) -> SplitClient? {
        let key = Key(matchingKey: matchingKey, bucketingKey: bucketingKey)
        guard let client = splitFactory?.client(key: key) else {
            print("Client couldn't be created")
            return nil
        }
        usedKeys.insert(key)

        return client
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
