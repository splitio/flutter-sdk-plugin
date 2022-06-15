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
        let key = buildKey(matchingKey: matchingKey, bucketingKey: bucketingKey)
        let semaphore = DispatchSemaphore(value: 0)
        let client = splitFactory?.client(key: key)
        usedKeys.insert(key)

        if (waitForReady) {
            client?.on(event: SplitEvent.sdkReady) {
                semaphore.signal()
            }
        } else {
            client?.on(event: SplitEvent.sdkReadyFromCache) {
                semaphore.signal()
            }
        }

        client?.on(event: SplitEvent.sdkReadyTimedOut) {
            semaphore.signal()
        }
        semaphore.wait(timeout: DispatchTime.now() + .seconds(10))

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

func buildKey(matchingKey: String, bucketingKey: String? = nil) -> Key {
    if (bucketingKey != "") {
        return Key(matchingKey: matchingKey, bucketingKey: bucketingKey)
    }

    return Key(matchingKey: matchingKey)
}
