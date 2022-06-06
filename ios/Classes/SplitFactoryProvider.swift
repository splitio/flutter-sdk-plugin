import Foundation
import Split

protocol SplitFactoryProvider {
    
    func getFactory() -> SplitFactory?
}

class DefaultSplitFactoryProvider : SplitFactoryProvider {
    
    private let splitFactory: SplitFactory?
    
    init(apiKey: String, matchingKey: String, bucketingKey: String, splitClientConfig: SplitClientConfig) {
        splitFactory = DefaultSplitFactoryBuilder()
            .setConfig(splitClientConfig)
            .setApiKey(apiKey)
            .setKey(buildKey(matchingKey: matchingKey, bucketingKey: bucketingKey))
            .build()
    }
    
    func getFactory() -> SplitFactory? {
        return splitFactory
    }
}
