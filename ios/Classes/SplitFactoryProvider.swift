import Foundation
import Split

protocol SplitFactoryProvider {

    func getFactory() -> SplitFactory?
}

protocol SplitProviderHelper {

    func getProvider(apiKey: String, matchingKey: String, bucketingKey: String?, splitClientConfig: SplitClientConfig) -> SplitFactoryProvider
}

class DefaultSplitFactoryProvider: SplitFactoryProvider {

    private let splitFactory: SplitFactory?

    init(apiKey: String, matchingKey: String, bucketingKey: String? = nil, splitClientConfig: SplitClientConfig) {
        splitFactory = DefaultSplitFactoryBuilder()
            .setConfig(splitClientConfig)
            .setApiKey(apiKey)
            .setKey(Key(matchingKey: matchingKey, bucketingKey: bucketingKey))
            .build()
    }

    func getFactory() -> SplitFactory? {
        return splitFactory
    }
}

class DefaultSplitProviderHelper: SplitProviderHelper {

    func getProvider(apiKey: String, matchingKey: String, bucketingKey: String? = nil, splitClientConfig: SplitClientConfig) -> SplitFactoryProvider {

        return DefaultSplitFactoryProvider(apiKey: apiKey, matchingKey: matchingKey, splitClientConfig: splitClientConfig)
    }
}
