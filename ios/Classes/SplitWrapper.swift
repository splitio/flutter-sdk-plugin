import Foundation
import Split

protocol SplitWrapper {
    
    func getClient(matchingKey: String, bucketingKey: String?) -> SplitClient?
    
    func destroy()
}

class DefaultSplitWrapper : SplitWrapper {

    private let splitFactory: SplitFactory?
    private var usedKeys: Set<Key>
    
    init(splitFactoryProvider: SplitFactoryProvider) {
        splitFactory = splitFactoryProvider.getFactory()
        usedKeys = Set()
    }
    
    func getClient(matchingKey: String, bucketingKey: String? = nil) -> SplitClient? {
        let key = buildKey(matchingKey: matchingKey, bucketingKey: bucketingKey)
        usedKeys.insert(key)
        
        return splitFactory?.client(key: key)
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

func buildKey(matchingKey: String, bucketingKey: String?) -> Key {
    if (bucketingKey != nil && bucketingKey != "") {
        return Key(matchingKey: matchingKey, bucketingKey: bucketingKey)
    }
    
    return Key(matchingKey: matchingKey)
}
