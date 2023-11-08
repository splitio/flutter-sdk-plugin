import XCTest
@testable import splitio_ios
@testable import Split

class SplitProviderHelperTests: XCTestCase {

    private var helper: DefaultSplitProviderHelper?

    func testHelperBuildsItsOwnProviderWhenNoneIsSupplied() throws {
        helper = DefaultSplitProviderHelper(splitFactoryProvider: nil)
        let provider = helper?.getProvider(apiKey: "", matchingKey: "", bucketingKey: "", splitClientConfig: SplitClientConfig())

        XCTAssertNotNil(provider)
    }

    func testHelperReturnsSuppliedProviderWhenExists() throws {
        let factoryProvider: SplitFactoryProviderStub? = SplitFactoryProviderStub()
        helper = DefaultSplitProviderHelper(splitFactoryProvider: factoryProvider)
        let provider: SplitFactoryProviderStub? = helper?.getProvider(apiKey: "", matchingKey: "", bucketingKey: "", splitClientConfig: SplitClientConfig()) as? SplitFactoryProviderStub

        XCTAssert(factoryProvider?.uuid == provider?.uuid)
    }
}
