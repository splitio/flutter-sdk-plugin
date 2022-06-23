import XCTest
@testable import splitio
@testable import Split

class SplitTests: XCTestCase {

    private var splitWrapper: SplitWrapper?

    override func setUpWithError() throws {
        splitWrapper = DefaultSplitWrapper(splitFactoryProvider: SplitFactoryProviderStub())
    }

    func testGetClient() throws {
        let client = splitWrapper?.getClient(matchingKey: "key", bucketingKey: "bucketing", waitForReady: false)
        XCTAssert(client != nil)
    }

    func testDestroy() throws {
        let client1 = splitWrapper?.getClient(matchingKey: "key", bucketingKey: "bucketing", waitForReady: false) as? SplitClientStub
        let client2 = splitWrapper?.getClient(matchingKey: "key", bucketingKey: nil, waitForReady: true) as? SplitClientStub
        splitWrapper?.destroy()

        XCTAssertTrue(client1?.destroyCalled.expectedFulfillmentCount == 1)
        XCTAssertTrue(client2?.destroyCalled.expectedFulfillmentCount == 1)
    }
}

class SplitFactoryProviderStub : SplitFactoryProvider {
    
    func getFactory() -> SplitFactory? {
        return SplitFactoryStub(apiKey: "dummy-key")
    }
}

class SplitFactoryStub: SplitFactory {

    var client: SplitClient
    
    var manager: SplitManager
    
    var version: String

    var apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
        client = SplitClientStub()
        manager = SplitManagerStub()
        version = "0.0.0-stub"
    }

    func client(key: Key) -> SplitClient {
        if (key.bucketingKey != nil) {
            return client
        } else {
            return SplitClientStub()
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
    
    var destroyCalled: XCTestExpectation = XCTestExpectation()
    var sdkReadyEventAction: SplitAction?

    func getTreatment(_ split: String, attributes: [String : Any]?) -> String {
        return SplitConstants.control
    }
    
    func getTreatment(_ split: String) -> String {
        return SplitConstants.control
    }
    
    func getTreatments(splits: [String], attributes: [String : Any]?) -> [String : String] {
        return ["feature": SplitConstants.control]
    }
    
    func getTreatmentWithConfig(_ split: String) -> SplitResult {
        return SplitResult(treatment: SplitConstants.control)
    }
    
    func getTreatmentWithConfig(_ split: String, attributes: [String : Any]?) -> SplitResult {
        return SplitResult(treatment: SplitConstants.control)
    }
    
    func getTreatmentsWithConfig(splits: [String], attributes: [String : Any]?) -> [String : SplitResult] {
        return ["feature": SplitResult(treatment: SplitConstants.control)]
    }
    
    func on(event: SplitEvent, execute action: @escaping SplitAction) {
        if (event == SplitEvent.sdkReady) {
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
    
    func track(trafficType: String, eventType: String, properties: [String:Any]?) -> Bool {
        return true
    }
    
    func track(trafficType: String, eventType: String, value: Double, properties: [String:Any]?) -> Bool {
        return true
    }
    
    func track(eventType: String, properties: [String:Any]?) -> Bool {
        return true
    }
    
    func track(eventType: String, value: Double, properties: [String:Any]?) -> Bool {
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
        destroyCalled.fulfill()
    }

    func destroy(completion: (() -> Void)?) {
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

class MethodChannelStub : FlutterMethodChannel {
    var methodName: String = ""
    var arguments: Any?

    override func invokeMethod(_ method: String, arguments: Any?) {
        self.methodName = method
        self.arguments = arguments
    }
}
