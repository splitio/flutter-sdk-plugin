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
            result: { (_: Any?) in
                return
            }
        )

        if let wrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(wrapper.matchingKeyValue == "user-key")
            XCTAssert(wrapper.bucketingKeyValue == "bucketing-key")
        }
    }

    func testDestroy() throws {
        methodParser?.onMethodCall(
            methodName: "destroy",
            arguments: [:],
            result: { (_: Any?) in
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

    func getClient(matchingKey: String, bucketingKey: String?) -> SplitClient? {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey ?? ""

        return SplitClientStub()
    }

    func getTreatment(matchingKey: String, splitName: String, bucketingKey: String?, attributes: [String: Any]?) -> String? {
        return "control"
    }

    func getTreatments(matchingKey: String, splits: [String], bucketingKey: String?, attributes: [String: Any]?) -> [String: String] {
        var result: [String: String] = [:]
        splits.forEach {
            result[$0] = "control"
        }

        return result
    }

    func getTreatmentWithConfig(matchingKey: String, splitName: String, bucketingKey: String?, attributes: [String: Any]?) -> SplitResult? {
        return SplitResult(treatment: "control", config: nil)
    }

    func getTreatmentsWithConfig(matchingKey: String, splits: [String], bucketingKey: String?, attributes: [String: Any]?) -> [String: SplitResult] {
        var result: [String: SplitResult] = [:]
        splits.forEach {
            result[$0] = SplitResult(treatment: "control", config: nil)
        }

        return result
    }

    func destroy() {
        destroyCalled = true
    }
}
