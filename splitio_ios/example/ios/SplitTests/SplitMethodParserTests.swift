import XCTest
@testable import splitio_ios
@testable import Split

class SplitMethodParserTests: XCTestCase {

    private var methodParser: SplitMethodParser?
    private var splitWrapper: SplitWrapper?
    private var argumentParser: ArgumentParser?
    private var methodChannel: FlutterMethodChannel?
    private var providerHelper: SplitProviderHelper?

    override func setUpWithError() throws {
        splitWrapper = SplitWrapperStub()
        argumentParser = DefaultArgumentParser()
        methodChannel = MethodChannelStub()
        providerHelper = SplitProviderHelperStub()
        methodParser = DefaultSplitMethodParser(splitWrapper: splitWrapper!, argumentParser: argumentParser!, methodChannel: methodChannel!, providerHelper: providerHelper!)
    }

    func testSuccessfulGetClient() throws {
        methodParser?.onMethodCall(
            methodName: "getClient",
            arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key"],
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

    func testGetSingleAttribute() {
        methodParser?.onMethodCall(methodName: "getAttribute", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "attributeName": "my_attr"], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(splitWrapper.attributeNameValue == "my_attr")
        }
    }

    func testGetAllAttributes() {
        methodParser?.onMethodCall(methodName: "getAllAttributes", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key"], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
        }
    }

    func testSetSingleAttribute() {
        methodParser?.onMethodCall(methodName: "setAttribute", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "attributeName": "my_attr", "value": "attr_value"], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(splitWrapper.attributeNameValue == "my_attr")
            XCTAssert(splitWrapper.attributeValue as? String == "attr_value")
        }
    }

    func testSetMultipleAttributes() {
        let expectedMap = ["bool_attr": true, "number_attr": 25.56, "string_attr": "attr-value", "list_attr": ["one", "two"]] as [String: Any]
        methodParser?.onMethodCall(methodName: "setAttributes", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "attributes": expectedMap], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(NSDictionary(dictionary: expectedMap).isEqual(to: splitWrapper.attributesValue ?? [:]))
        }
    }

    func testRemoveAttribute() {
        methodParser?.onMethodCall(methodName: "removeAttribute", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key", "attributeName": "my_attr"], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
            XCTAssert(splitWrapper.attributeNameValue == "my_attr")
        }
    }

    func testClearAttributes() {
        methodParser?.onMethodCall(methodName: "clearAttributes", arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key"], result: { (_: Any?) in
            return
        })

        if let splitWrapper = (splitWrapper as? SplitWrapperStub) {
            XCTAssert(splitWrapper.matchingKeyValue == "user-key")
            XCTAssert(splitWrapper.bucketingKeyValue == "bucketing-key")
        }
    }

    func testDestroy() throws {
        methodParser?.onMethodCall(
            methodName: "destroy",
            arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key"],
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

    func testFlush() throws {
        methodParser?.onMethodCall(
            methodName: "flush",
            arguments: ["matchingKey": "user-key", "bucketingKey": "bucketing-key"],
            result: { (_: Any?) in
                return
            }
        )

        guard let wrapper = splitWrapper as? SplitWrapperStub else {
            XCTFail()
            return
        }

        XCTAssert(wrapper.flushCalled)
    }

    func testSplitNames() {
        methodParser?.onMethodCall(methodName: "splitNames", arguments: [], result: { (_: Any?) in return })

        guard let wrapper = splitWrapper as? SplitWrapperStub else {
            XCTFail()
            return
        }

        XCTAssert(wrapper.splitNamesCalled)
    }

    func testSplits() {
        methodParser?.onMethodCall(methodName: "splits", arguments: [], result: { (_: Any?) in return })

        guard let wrapper = splitWrapper as? SplitWrapperStub else {
            XCTFail()
            return
        }

        XCTAssert(wrapper.splitsCalled)
    }

    func testSplit() {
        methodParser?.onMethodCall(methodName: "split", arguments: ["splitName": "my-split"], result: { (_: Any?) in return })

        guard let wrapper = splitWrapper as? SplitWrapperStub else {
            XCTFail()
            return
        }

        XCTAssert(wrapper.splitNameValue == "my-split")
    }

    func testInit() {
        methodParser?.onMethodCall(methodName: "init", arguments: [
            "apiKey": "api-key", "matchingKey": "matching-key", "bucketingKey": "bucketing-key",
            "sdkConfiguration": ["streamingEnabled": false, "impressionListener": true]
        ], result: { (_: Any?) in })

        guard let providerHelper = providerHelper as? SplitProviderHelperStub else {
            XCTFail()
            return
        }

        XCTAssert(providerHelper.apiKeyValue == "api-key")
        XCTAssert(providerHelper.matchingKeyValue == "matching-key")
        XCTAssert(providerHelper.bucketingKeyValue == "bucketing-key")
        XCTAssert(providerHelper.splitClientConfigValue?.impressionListener != nil)
        XCTAssert(providerHelper.splitClientConfigValue?.streamingEnabled == false)
    }

    func testGetUserConsent() {
        methodParser?.onMethodCall(methodName: "getUserConsent", arguments: [], result: { (_: Any?) in })

        guard let wrapper = splitWrapper as? SplitWrapperStub else {
            XCTFail()
            return
        }

        XCTAssert(wrapper.userConsent == "unknown")
    }

    func testSetUserConsent() {
        methodParser?.onMethodCall(methodName: "setUserConsent", arguments: [], result: { (_: Any?) in })

        guard let wrapper = splitWrapper as? SplitWrapperStub else {
            XCTFail()
            return
        }

        XCTAssert(wrapper.userConsent == "declined")
    }
}

class SplitWrapperStub: SplitWrapper {

    var destroyCalled = false
    var flushCalled = false
    var matchingKeyValue = ""
    var bucketingKeyValue: String?
    var splitNameValue = ""
    var flagSetValue = ""
    var flagSetsValue: [String] = []
    var splitsValue: [String]?
    var attributesValue: [String: Any]?
    var eventTypeValue: String = ""
    var propertiesValue: [String: Any]?
    var valueValue: Double?
    var attributeValue: Any?
    var trafficTypeValue: String = ""
    var attributeNameValue: String = ""
    var splitsCalled = false
    var splitNamesCalled = false
    var userConsent = "unknown"

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

    func getTreatmentsByFlagSet(matchingKey: String, flagSet: String, bucketingKey: String?, attributes: [String : Any]?) -> [String : String] {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        flagSetValue = flagSet
        attributeValue = attributes

        return [:]
    }

    func getTreatmentsByFlagSets(matchingKey: String, flagSets: [String], bucketingKey: String?, attributes: [String : Any]?) -> [String : String] {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        flagSetsValue = flagSets
        attributeValue = attributes

        return [:]
    }

    func getTreatmentsWithConfigByFlagSet(matchingKey: String, flagSet: String, bucketingKey: String?, attributes: [String : Any]?) -> [String : SplitResult] {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        flagSetValue = flagSet
        attributeValue = attributes

        return [:]
    }

    func getTreatmentsWithConfigByFlagSets(matchingKey: String, flagSets: [String], bucketingKey: String?, attributes: [String : Any]?) -> [String : SplitResult] {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        flagSetsValue = flagSets
        attributeValue = attributes

        return [:]
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

    func getAttribute(matchingKey: String, bucketingKey: String?, attributeName: String) -> Any? {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        attributeNameValue = attributeName
        return nil
    }

    func getAllAttributes(matchingKey: String, bucketingKey: String?) -> [String: Any] {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        return [:]
    }

    func setAttribute(matchingKey: String, bucketingKey: String?, attributeName: String, value: Any?) -> Bool {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        attributeNameValue = attributeName
        attributeValue = value
        return true
    }

    func setAttributes(matchingKey: String, bucketingKey: String?, attributes: [String: Any?]) -> Bool {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        attributesValue = attributes
        return true
    }

    func removeAttribute(matchingKey: String, bucketingKey: String?, attributeName: String) -> Bool {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        attributeNameValue = attributeName
        return true
    }

    func clearAttributes(matchingKey: String, bucketingKey: String?) -> Bool {
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        return true
    }

    func destroy(matchingKey: String, bucketingKey: String?) {
        destroyCalled = true
    }

    func flush(matchingKey: String, bucketingKey: String?) {
        flushCalled = true
    }

    func splitNames() -> [String] {
        splitNamesCalled = true
        return []
    }

    func splits() -> [SplitView] {
        splitsCalled = true
        return []
    }

    func split(splitName: String) -> SplitView? {
        splitNameValue = splitName
        return nil
    }

    func getUserConsent() -> String {
        return userConsent
    }

    func setUserConsent(enabled: Bool) {
        if (enabled) {
            userConsent = "granted"
        } else {
            userConsent = "declined"
        }
    }
}

class SplitProviderHelperStub: SplitProviderHelper {

    var apiKeyValue = ""
    var matchingKeyValue = ""
    var bucketingKeyValue: String? = ""
    var splitClientConfigValue: SplitClientConfig?

    func getProvider(apiKey: String, matchingKey: String, bucketingKey: String?, splitClientConfig: SplitClientConfig) -> SplitFactoryProvider {
        apiKeyValue = apiKey
        matchingKeyValue = matchingKey
        bucketingKeyValue = bucketingKey
        splitClientConfigValue = splitClientConfig

        return SplitFactoryProviderStub()
    }
}
