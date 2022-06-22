import Foundation
import Split

protocol SplitWrapper {

    func getClient(matchingKey: String, bucketingKey: String?, waitForReady: Bool, methodChannel: FlutterMethodChannel) -> SplitClient?

    func destroy()
}

class DefaultSplitWrapper : SplitWrapper {

    private let splitFactory: SplitFactory?
    private var usedKeys: Set<Key>

    init(splitFactoryProvider: SplitFactoryProvider) {
        splitFactory = splitFactoryProvider.getFactory()
        usedKeys = Set()
    }

    func getClient(matchingKey: String, bucketingKey: String? = nil, waitForReady: Bool = false, methodChannel: FlutterMethodChannel) -> SplitClient? {
        let key = buildKey(matchingKey: matchingKey, bucketingKey: bucketingKey)
        let client = splitFactory?.client(key: key)
        usedKeys.insert(key)

        addEventListeners(client: client, matchingKey: matchingKey, bucketingKey: bucketingKey, methodChannel: methodChannel, waitForReady: waitForReady)

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

    private func addEventListeners(client: SplitClient?, matchingKey: String, bucketingKey: String?, methodChannel: FlutterMethodChannel, waitForReady: Bool) {
        if (waitForReady) {
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
        args[Constants.Arguments.ARG_MATCHING_KEY] = matchingKey

        if let bucketing = bucketingKey {
            args[Constants.Arguments.ARG_BUCKETING_KEY] = bucketing
        }

        methodChannel.invokeMethod(Constants.Methods.METHOD_CLIENT_READY, arguments: args)
    }
}

func buildKey(matchingKey: String, bucketingKey: String? = nil) -> Key {
    if (bucketingKey != "") {
        return Key(matchingKey: matchingKey, bucketingKey: bucketingKey)
    }

    return Key(matchingKey: matchingKey)
}
