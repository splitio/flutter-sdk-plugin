import XCTest
@testable import splitio
@testable import Split

class SplitMethodParserTests: XCTestCase {

    private var methodParser: SplitMethodParser?
    private var splitWrapper: SplitWrapper?
    private var argumentParser: ArgumentParser?
    private var methodChannel: FlutterMethodChannel?

    override func setUpWithError() throws {
        splitWrapper = SplitWrapperStub()
        argumentParser = DefaultArgumentParser()
        methodChannel = MethodChannelStub()
        methodParser = DefaultSplitMethodParser(splitWrapper: splitWrapper!, argumentParser: argumentParser!, methodChannel: methodChannel!)
    }

    func testSuccessfulGetClient() throws {

        methodParser?.onMethodCall(
            methodName: "getClient",
            arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "waitForReady": true],
            result: { (param: Any?) in
                return
            }
        )

        if let wrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(wrapper.matchingKeyValue == "user-key")
            XCTAssert(wrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(wrapper.waitForReadyValue)
        }
    }

    func testDestroy() throws {
        methodParser?.onMethodCall(
            methodName: "destroy",
            arguments: [:],
            result: { (param: Any?) in
                return
            }
        )

        guard let wrapper = splitWrapper as? SplitWrapperStub else {
            XCTFail()
            return
        }

        XCTAssert(wrapper.destroyCalled)
    }
}

class SplitWrapperStub: SplitWrapper {

    var destroyCalled = false
    var matchingKeyValue = ""
    var bucketingKeyValue = ""
    var waitForReadyValue = false

    func getClient(matchingKey: String, bucketingKey: String?, waitForReady: Bool) -> SplitClient? {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey ?? ""
        waitForReadyValue = waitForReady

        return SplitClientStub()
    }

    func destroy() {
        destroyCalled = true
    }
}
