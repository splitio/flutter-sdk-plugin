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

    func testGetTreatment() {
        methodParser?.onMethodCall(methodName: "getTreatment", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "splitName": "split1", "attributes": ["age": 50]], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(splitWrapper.splitNameValue == "split1")
            XCTAssert(NSDictionary(dictionary: ["age": 50]).isEqual(to: splitWrapper.attributesValue!))
        }
    }

    func testGetTreatmentWithConfig() {
        methodParser?.onMethodCall(methodName: "getTreatmentWithConfig", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "splitName": "split1", "attributes": ["age": 50]], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(splitWrapper.splitNameValue == "split1")
            XCTAssert(splitWrapper.attributesValue != nil)
            XCTAssert(NSDictionary(dictionary: ["age": 50]).isEqual(to: splitWrapper.attributesValue!))
        }
    }

    func testGetTreatments() {
        methodParser?.onMethodCall(methodName: "getTreatments", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "splitName": ["split1"], "attributes": ["age": 50]], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(splitWrapper.splitsValue == ["split1"])
            XCTAssert(NSDictionary(dictionary: ["age": 50]).isEqual(to: splitWrapper.attributesValue!))
        }
    }

    func testGetTreatmentsWithConfig() {
        methodParser?.onMethodCall(methodName: "getTreatmentsWithConfig", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "splitName": ["split1"], "attributes": ["age": 50]], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(splitWrapper.splitsValue == ["split1"])
            XCTAssert(NSDictionary(dictionary: ["age": 50]).isEqual(to: splitWrapper.attributesValue!))
        }
    }

    func testTrackWithValue() {
        methodParser?.onMethodCall(methodName: "track", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "eventType": "my_event", "value": 25.20], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(splitWrapper.eventTypeValue == "my_event")
            XCTAssert(splitWrapper.valueValue == 25.20)
        }
    }

    func testTrackWithInvalidValue() {
        methodParser?.onMethodCall(methodName: "track", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "eventType": "my_event", "value": "25.20"], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(splitWrapper.eventTypeValue == "my_event")
            XCTAssert(splitWrapper.valueValue == nil)
        }
    }

    func testTrackWithValueAndProperties() {
        methodParser?.onMethodCall(methodName: "track", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "eventType": "my_event", "value": 25.20, "properties": ["age": 50]], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(splitWrapper.eventTypeValue == "my_event")
            XCTAssert(splitWrapper.valueValue == 25.20)
            XCTAssert(NSDictionary(dictionary: ["age": 50]).isEqual(to: splitWrapper.propertiesValue!))
        }
    }

    func testTrackWithEverything() {
        methodParser?.onMethodCall(methodName: "track", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "trafficType": "account", "eventType": "my_event", "value": 25.20, "properties": ["age": 50]], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(splitWrapper.eventTypeValue == "my_event")
            XCTAssert(splitWrapper.valueValue == 25.20)
            XCTAssert(splitWrapper.trafficTypeValue == "account")
            XCTAssert(NSDictionary(dictionary: ["age": 50]).isEqual(to: splitWrapper.propertiesValue!))
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
    var bucketingKeyValue: String?
    var splitNameValue = ""
    var splitsValue: [String]?
    var attributesValue: [String: Any]?
    var eventTypeValue: String = ""
    var propertiesValue: [String: Any]?
    var valueValue: Double?
    var trafficTypeValue: String = ""

    func getClient(matchingKey: String, bucketingKey: String?) -> SplitClient? {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey ?? ""

        return SplitClientStub()
    }

    func getTreatment(matchingKey: String, splitName: String, bucketingKey: String?, attributes: [String: Any]?) -> String? {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        splitNameValue = splitName
        attributesValue = attributes
        return "control"
    }

    func getTreatments(matchingKey: String, splits: [String], bucketingKey: String?, attributes: [String: Any]?) -> [String: String] {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        splitsValue = splits
        attributesValue = attributes
        var result: [String: String] = [:]
        splits.forEach {
            result[$0] = "control"
        }

        return result
    }

    func getTreatmentWithConfig(matchingKey: String, splitName: String, bucketingKey: String?, attributes: [String: Any]?) -> SplitResult? {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        splitNameValue = splitName
        attributesValue = attributes
        return SplitResult(treatment: "control", config: nil)
    }

    func getTreatmentsWithConfig(matchingKey: String, splits: [String], bucketingKey: String?, attributes: [String: Any]?) -> [String: SplitResult] {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        splitsValue = splits
        attributesValue = attributes
        var result: [String: SplitResult] = [:]
        splits.forEach {
            result[$0] = SplitResult(treatment: "control", config: nil)
        }

        return result
    }

    func track(matchingKey: String, bucketingKey: String?, eventType: String, trafficType: String?, value: Double?, properties: [String: Any]) -> Bool {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        eventTypeValue = eventType
        trafficTypeValue = trafficType ?? ""
        valueValue = value
        propertiesValue = properties

        return true
    }

    func destroy() {
        destroyCalled = true
    }
}
