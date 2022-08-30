import XCTest
@testable import splitio
@testable import Split

class SplitTests: XCTestCase {

    private var splitWrapper: SplitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStub())

    func testGetClient() throws {
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStub())
        let client = splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        XCTAssert(client != nil)
    }

    func testGetTreatment() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        let treatment = splitWrapper.getTreatment(matchingKey: "key", splitName: "split", bucketingKey: "bucketing", attributes: nil)
        XCTAssert(treatment != nil)
        XCTAssert(client.getTreatmentCalled)
    }

    func testGetTreatments() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        let treatment = splitWrapper.getTreatments(matchingKey: "key", splits: ["split"], bucketingKey: "bucketing", attributes: nil)
        XCTAssert(!treatment.isEmpty)
        XCTAssert(client.getTreatmentsCalled)
    }

    func testGetTreatmentWithConfig() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        let treatment = splitWrapper.getTreatmentWithConfig(matchingKey: "key", splitName: "split", bucketingKey: "bucketing", attributes: nil)
        XCTAssert(treatment != nil)
        XCTAssert(client.getTreatmentWithConfigCalled)
    }

    func testGetTreatmentsWithConfig() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        let treatment = splitWrapper.getTreatmentsWithConfig(matchingKey: "key", splits: ["split"], bucketingKey: "bucketing", attributes: nil)
        XCTAssert(!treatment.isEmpty)
        XCTAssert(client.getTreatmentsWithConfigCalled)
    }

    func testTrack() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        let track = splitWrapper.track(matchingKey: "key", bucketingKey: "bucketing", eventType: "my_event", trafficType: "account", value: 25.50, properties: ["age": 50])
        XCTAssert(track)
        XCTAssert(client.eventTypeValue == "my_event")
        XCTAssert(client.trafficTypeValue == "account")
        XCTAssert(client.valueValue == 25.50)
        XCTAssert(NSDictionary(dictionary: ["age": 50]).isEqual(to: client.propertiesValue!))
    }

    func testTrackWithoutTrafficType() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        let track = splitWrapper.track(matchingKey: "key", bucketingKey: "bucketing", eventType: "my_event", trafficType: nil, value: 25.50, properties: ["age": 50])
        XCTAssert(track)
        XCTAssert(client.eventTypeValue == "my_event")
        XCTAssert(client.trafficTypeValue == nil)
        XCTAssert(client.valueValue == 25.50)
        XCTAssert(NSDictionary(dictionary: ["age": 50]).isEqual(to: client.propertiesValue!))
    }

    func testTrackWithoutTrafficTypeNorValue() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        let track = splitWrapper.track(matchingKey: "key", bucketingKey: "bucketing", eventType: "my_event", trafficType: nil, value: nil, properties: ["age": 50])
        XCTAssert(track)
        XCTAssert(client.eventTypeValue == "my_event")
        XCTAssert(client.trafficTypeValue == nil)
        XCTAssert(client.valueValue == nil)
        XCTAssert(NSDictionary(dictionary: ["age": 50]).isEqual(to: client.propertiesValue!))
    }

    func testTrackWithoutValue() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        let track = splitWrapper.track(matchingKey: "key", bucketingKey: "bucketing", eventType: "my_event", trafficType: "account", value: nil, properties: ["age": 50])
        XCTAssert(track)
        XCTAssert(client.eventTypeValue == "my_event")
        XCTAssert(client.trafficTypeValue == "account")
        XCTAssert(client.valueValue == nil)
        XCTAssert(NSDictionary(dictionary: ["age": 50]).isEqual(to: client.propertiesValue!))
    }

    func testGetAttribute() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        splitWrapper.getAttribute(matchingKey: "key", bucketingKey: "bucketing", attributeName: "my_attr")
        XCTAssert(client.attributeNameValue == "my_attr")
    }

    func testGetAllAttributes() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getAllAttributes(matchingKey: "key", bucketingKey: "bucketing")
        XCTAssert(client.attributeNameValue == "")
    }

    func testSetAttribute() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        splitWrapper.setAttribute(matchingKey: "key", bucketingKey: "bucketing", attributeName: "my_attr", value: "attr_value")
        XCTAssert(client.attributeNameValue == "my_attr")

        let value = client.attributeValue as? String?
        XCTAssert(value == "attr_value")
    }

    func testMultipleAttributes() {
        let client = SplitClientStub()
        let expectedMap = ["bool_attr": true, "number_attr": 25.56, "string_attr": "attr-value", "list_attr": ["one", "two"]] as [String: Any]
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        splitWrapper.setAttributes(matchingKey: "key", bucketingKey: "bucketing", attributes: expectedMap)

        XCTAssert(NSDictionary(dictionary: expectedMap).isEqual(to: client.attributesMapValue))
    }

    func testRemoveAttribute() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing")
        splitWrapper.removeAttribute(matchingKey: "key", bucketingKey: "bucketing", attributeName: "my_attr")
        XCTAssert(client.attributeNameValue == "my_attr")
    }

    func testFlush() {
        let client = SplitClientStub()
        var usedKeys = Set<Key>()
        usedKeys.insert(Key(matchingKey: "key", bucketingKey: "bucketing"))
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client), usedKeys: usedKeys)
        splitWrapper.flush(matchingKey: "key", bucketingKey: "bucketing")
        XCTAssert(client.flushCalled)
    }

    func testDestroy() {
        let client = SplitClientStub()
        var usedKeys = Set<Key>()
        usedKeys.insert(Key(matchingKey: "key", bucketingKey: "bucketing"))
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client), usedKeys: usedKeys)
        splitWrapper.destroy(matchingKey: "key", bucketingKey: "bucketing")
        XCTAssert(client.destroyCalled)
    }

    func testSplitNames() {
        let manager = SplitManagerStub()
        let factoryProvider = SplitFactoryProviderStub(manager: manager)
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: factoryProvider)
        _ = splitWrapper.splitNames()
        XCTAssert(manager.splitNamesCalled == true)
    }

    func testSplits() {
        let manager = SplitManagerStub()
        let factoryProvider = SplitFactoryProviderStub(manager: manager)
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: factoryProvider)
        _ = splitWrapper.splits()
        XCTAssert(manager.splitsCalled == true)
    }

    func testSplit() {
        let manager = SplitManagerStub()
        let factoryProvider = SplitFactoryProviderStub(manager: manager)
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: factoryProvider)
        let split = splitWrapper.split(splitName: "my-split")
        XCTAssert(manager.splitNameValue == "my-split")
    }
}

class SplitFactoryProviderStub: SplitFactoryProvider {

    // For testing purposes only
    let uuid: Int = Int.random(in: 0..<1000)

    var manager: SplitManagerStub?

    init(manager: SplitManagerStub?) {
        self.manager = manager
    }

    convenience init() {
        self.init(manager: nil)
    }

    func getFactory() -> SplitFactory? {
        if let manager = manager {
            return SplitFactoryStub(apiKey: "dummy-key", manager: manager)
        } else {
            return SplitFactoryStub(apiKey: "dummy-key")
        }
    }
}

class SplitFactoryProviderStubWithClient: SplitFactoryProvider {

    // For testing purposes only
    let uuid: Int = Int.random(in: 0..<1000)

    let client: SplitClientStub

    init(client: SplitClientStub) {
        self.client = client
    }

    func getFactory() -> SplitFactory? {
        return SplitFactoryStub(apiKey: "dummy-key", client: self.client)
    }
}

class SplitFactoryStub: SplitFactory {

    var client: SplitClient

    var nilBucketingKeyClient: SplitClient

    var manager: SplitManager = SplitManagerStub()

    var version: String

    var apiKey: String

    init(apiKey: String, client: SplitClient) {
        self.apiKey = apiKey
        self.client = client
        self.nilBucketingKeyClient = SplitClientStub()
        manager = SplitManagerStub()
        version = "0.0.0-stub"
    }

    convenience init(apiKey: String) {
        self.init(apiKey: apiKey, client: SplitClientStub())
    }

    convenience init(apiKey: String, manager: SplitManagerStub) {
        self.init(apiKey: apiKey)
        self.manager = manager
    }

    func client(key: Key) -> SplitClient {
        if key.bucketingKey != nil {
            return client
        } else {
            return nilBucketingKeyClient
        }
    }

    func client(matchingKey: String) -> SplitClient {
        return client
    }

    func client(matchingKey: String, bucketingKey: String?) -> SplitClient {
        return client
    }
}

class SplitClientStub: SplitClient {

    var destroyCalled: Bool = false
    var getTreatmentCalled: Bool = false
    var getTreatmentWithConfigCalled: Bool = false
    var getTreatmentsCalled: Bool = false
    var getTreatmentsWithConfigCalled: Bool = false
    var flushCalled: Bool = false
    var eventTypeValue: String = ""
    var trafficTypeValue: String?
    var valueValue: Double?
    var propertiesValue: [String: Any]? = [:]
    var attributeNameValue: String = ""
    var attributeValue: Any?
    var attributesMapValue: [String: Any] = [:]
    var clearAttributesCalled: Bool = false
    var sdkReadyEventAction: SplitAction?

    func getTreatment(_ split: String, attributes: [String: Any]?) -> String {
        getTreatmentCalled = true
        return SplitConstants.control
    }

    func getTreatment(_ split: String) -> String {
        getTreatmentCalled = true
        return SplitConstants.control
    }

    func getTreatments(splits: [String], attributes: [String: Any]?) -> [String: String] {
        getTreatmentsCalled = true
        return ["feature": SplitConstants.control]
    }

    func getTreatmentWithConfig(_ split: String) -> SplitResult {
        getTreatmentWithConfigCalled = true
        return SplitResult(treatment: SplitConstants.control)
    }

    func getTreatmentWithConfig(_ split: String, attributes: [String: Any]?) -> SplitResult {
        getTreatmentWithConfigCalled = true
        return SplitResult(treatment: SplitConstants.control)
    }

    func getTreatmentsWithConfig(splits: [String], attributes: [String: Any]?) -> [String: SplitResult] {
        getTreatmentsWithConfigCalled = true
        return ["feature": SplitResult(treatment: SplitConstants.control)]
    }

    func on(event: SplitEvent, execute action: @escaping SplitAction) {
        if event == SplitEvent.sdkReady {
            sdkReadyEventAction = action
        }
    }

    func track(trafficType: String, eventType: String) -> Bool {
        return true
    }

    func track(trafficType: String, eventType: String, value: Double) -> Bool {
        return true
    }

    func track(eventType: String) -> Bool {
        return true
    }

    func track(eventType: String, value: Double) -> Bool {
        eventTypeValue = eventType
        valueValue = value
        return true
    }

    func track(trafficType: String, eventType: String, properties: [String: Any]?) -> Bool {
        eventTypeValue = eventType
        trafficTypeValue = trafficType
        propertiesValue = properties
        return true
    }

    func track(trafficType: String, eventType: String, value: Double, properties: [String: Any]?) -> Bool {
        eventTypeValue = eventType
        trafficTypeValue = trafficType
        valueValue = value
        propertiesValue = properties
        return true
    }

    func track(eventType: String, properties: [String: Any]?) -> Bool {
        eventTypeValue = eventType
        propertiesValue = properties
        return true
    }

    func track(eventType: String, value: Double, properties: [String: Any]?) -> Bool {
        eventTypeValue = eventType
        valueValue = value
        propertiesValue = properties
        return true
    }

    func setAttribute(name: String, value: Any) -> Bool {
        attributeNameValue = name
        attributeValue = value
        return true
    }

    func getAttribute(name: String) -> Any? {
        attributeNameValue = name
        return nil
    }

    func setAttributes(_ values: [String: Any]) -> Bool {
        attributesMapValue = values
        return true
    }

    func getAttributes() -> [String: Any]? {
        return nil
    }

    func removeAttribute(name: String) -> Bool {
        attributeNameValue = name
        return true
    }

    func clearAttributes() -> Bool {
        return true
    }

    func flush() {
        flushCalled = true
    }

    func destroy() {
        destroyCalled = true
    }

    func destroy(completion: (() -> Void)?) {
        destroyCalled = true
    }
}

class SplitManagerStub: SplitManager, Destroyable {

    var splitNamesCalled = false

    var splitsCalled = false

    var splitNameValue = ""

    var splits: [SplitView] {
        get {
            splitsCalled = true
            return []
        }
    }

    var splitNames: [String] {
        get {
            splitNamesCalled = true
            return []
        }
    }

    func split(featureName: String) -> SplitView? {
        splitNameValue = featureName
        return nil
    }

    var destroyCalled = false
    func destroy() {
        destroyCalled = true
    }
}

class MethodChannelStub: FlutterMethodChannel {
    var methodName: String = ""
    var arguments: Any?

    override func invokeMethod(_ method: String, arguments: Any?) {
        self.methodName = method
        self.arguments = arguments
    }
}
