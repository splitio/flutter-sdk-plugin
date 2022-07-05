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
        let treatment = splitWrapper.getTreatment(matchingKey: "key", splitName: "split", bucketingKey: "bucketing", attributes: nil)
        XCTAssert(treatment != nil)
        XCTAssert(client.getTreatmentCalled)
    }

    func testGetTreatments() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        let treatment = splitWrapper.getTreatments(matchingKey: "key", splits: ["split"], bucketingKey: "bucketing", attributes: nil)
        XCTAssert(!treatment.isEmpty)
        XCTAssert(client.getTreatmentsCalled)
    }

    func testGetTreatmentWithConfig() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        let treatment = splitWrapper.getTreatmentWithConfig(matchingKey: "key", splitName: "split", bucketingKey: "bucketing", attributes: nil)
        XCTAssert(treatment != nil)
        XCTAssert(client.getTreatmentWithConfigCalled)
    }

    func testGetTreatmentsWithConfig() {
        let client = SplitClientStub()
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStubWithClient(client: client))
        let treatment = splitWrapper.getTreatmentsWithConfig(matchingKey: "key", splits: ["split"], bucketingKey: "bucketing", attributes: nil)
        XCTAssert(!treatment.isEmpty)
        XCTAssert(client.getTreatmentsWithConfigCalled)
    }

    func testDestroy() throws {
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStub())
        let client1 = splitWrapper.getClient(matchingKey: "key", bucketingKey: "bucketing") as? SplitClientStub
        let client2 = splitWrapper.getClient(matchingKey: "key", bucketingKey: nil) as? SplitClientStub
        splitWrapper.destroy()

        XCTAssertTrue(client1?.destroyCalled == true)
        XCTAssertTrue(client2?.destroyCalled == true)
    }
}

class SplitFactoryProviderStub: SplitFactoryProvider {

    func getFactory() -> SplitFactory? {
        return SplitFactoryStub(apiKey: "dummy-key")
    }
}

class SplitFactoryProviderStubWithClient: SplitFactoryProvider {

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

    var manager: SplitManager

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
        return true
    }

    func track(trafficType: String, eventType: String, properties: [String: Any]?) -> Bool {
        return true
    }

    func track(trafficType: String, eventType: String, value: Double, properties: [String: Any]?) -> Bool {
        return true
    }

    func track(eventType: String, properties: [String: Any]?) -> Bool {
        return true
    }

    func track(eventType: String, value: Double, properties: [String: Any]?) -> Bool {
        return true
    }

    func setAttribute(name: String, value: Any) -> Bool {
        return true
    }

    func getAttribute(name: String) -> Any? {
        return nil
    }

    func setAttributes(_ values: [String: Any]) -> Bool {
        return true
    }

    func getAttributes() -> [String: Any]? {
        return nil
    }

    func removeAttribute(name: String) -> Bool {
        return true
    }

    func clearAttributes() -> Bool {
        return true
    }

    func flush() {
    }

    func destroy() {
        destroyCalled = true
    }

    func destroy(completion: (() -> Void)?) {
        destroyCalled = true
    }
}

class SplitManagerStub: SplitManager, Destroyable {
    var splits: [SplitView]
    var splitNames: [String]

    init() {
        splits = []
        splitNames = []
    }

    func split(featureName: String) -> SplitView? {
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
