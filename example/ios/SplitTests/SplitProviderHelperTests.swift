import XCTest
@testable import splitio
@testable import Split

class SplitProviderHelperTests: XCTestCase {

    private var helper: DefaultSplitProviderHelper?

    func testHelperBuildsItsOwnProviderWhenNoneIsSupplied() throws {
        helper = DefaultSplitProviderHelper(splitFactoryProvider: nil)
        let provider = helper?.getProvider(apiKey: "", matchingKey: "", bucketingKey: "", splitClientConfig: SplitClientConfig())

        XCTAssertNotNil(provider)
    }

    func testHelperReturnsSuppliedProviderWhenExists() throws {
        let factoryProvider: SplitFactoryProvider? = SplitFactoryProviderStub()
        helper = DefaultSplitProviderHelper(splitFactoryProvider: factoryProvider)
        let provider: SplitFactoryProvider? = helper?.getProvider(apiKey: "", matchingKey: "", bucketingKey: "", splitClientConfig: SplitClientConfig())

        XCTAssert(factoryProvider?.uuid == provider?.uuid)
    }
}
