import XCTest
@testable import splitio_ios

class SplitClientConfigHelperTests: XCTestCase {

    func testConfigValuesAreMappedCorrectly() throws {
        let configValues: [String: Any?] = ["featuresRefreshRate": 80000,
        "segmentsRefreshRate": 70000,
        "impressionsRefreshRate": 60000,
        "telemetryRefreshRate": 2000,
        "eventsQueueSize": 3999,
        "impressionsQueueSize": 2999,
        "eventFlushInterval": 40000,
        "eventsPerPush": 5000,
        "trafficType": "none",
        "connectionTimeOut": 10,
        "readTimeout": 25,
        "disableLabels": true,
        "enableDebug": true,
        "proxyHost": "https://proxy",
        "ready": 25,
        "streamingEnabled": true,
        "persistentAttributesEnabled": true,
        "syncConfig": ["syncConfigNames": ["split1", "split2"], "syncConfigPrefixes": ["split_", "my_split_"]]]

        let splitClientConfig = SplitClientConfigHelper.fromMap(configurationMap: configValues, impressionListener: nil)

        XCTAssert(80000 == splitClientConfig.featuresRefreshRate)
        XCTAssert(70000 == splitClientConfig.segmentsRefreshRate)
        XCTAssert(60000 == splitClientConfig.impressionRefreshRate)
        XCTAssert(2000 == splitClientConfig.telemetryRefreshRate)
        XCTAssert(3999 == splitClientConfig.eventsQueueSize)
        XCTAssert(2999 == splitClientConfig.impressionsQueueSize)
        XCTAssert(40000 == splitClientConfig.eventsPushRate)
        XCTAssert(5000 == splitClientConfig.eventsPerPush)
        XCTAssert("none" == splitClientConfig.trafficType)
        XCTAssert(splitClientConfig.isDebugModeEnabled)
        XCTAssert(splitClientConfig.streamingEnabled)
        XCTAssert(splitClientConfig.persistentAttributesEnabled)
    }
}
