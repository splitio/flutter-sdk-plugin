import XCTest
@testable import splitio_ios
@testable import Split

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
            "proxyHost": "https://proxy",
            "ready": 25,
            "streamingEnabled": true,
            "persistentAttributesEnabled": true,
            "impressionsMode": "none",
            "syncEnabled": false,
            "userConsent": "declined",
            "encryptionEnabled": true,
            "logLevel": "verbose",
            "readyTimeout": 10
        ]

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
        XCTAssert(splitClientConfig.streamingEnabled)
        XCTAssert(splitClientConfig.persistentAttributesEnabled)
        XCTAssertEqual("NONE", splitClientConfig.impressionsMode)
        XCTAssertFalse(splitClientConfig.syncEnabled)
        XCTAssertEqual(.declined, splitClientConfig.userConsent)
        XCTAssertTrue(splitClientConfig.encryptionEnabled)
        XCTAssertEqual(.verbose, splitClientConfig.logLevel)
        XCTAssertEqual(10000, splitClientConfig.sdkReadyTimeOut)
        XCTAssertNil(splitClientConfig.certificatePinningConfig)
    }

    func testEnableDebugLogLevelIsMappedCorrectly() {
        let configValues: [String: Any] = ["enableDebug": true]
        let splitClientConfig = SplitClientConfigHelper.fromMap(configurationMap: configValues, impressionListener: nil)
        XCTAssertEqual(SplitLogLevel.debug, splitClientConfig.logLevel)
    }

    func testLogLevelsAreMappedCorrectly() {
        let logLevels = ["verbose", "debug", "info", "warning", "error", "none"]
        let expectedLogLevels: [SplitLogLevel] = [.verbose, .debug, .info, .warning, .error, .none]

        for (index, logLevel) in logLevels.enumerated() {
            let configValues: [String: Any] = ["logLevel": logLevel]
            let config = SplitClientConfigHelper.fromMap(configurationMap: configValues, impressionListener: nil)
            XCTAssertEqual(expectedLogLevels[index], config.logLevel)
        }
    }

    func testUserConsentIsMappedCorrectly() {
        let userConsents = ["granted", "unknown", "declined", "any"]
        let expectedUserConsents: [UserConsent] = [.granted, .unknown, .declined, .granted]

        for (index, userConsent) in userConsents.enumerated() {
            let configValues: [String: Any] = ["userConsent": userConsent]
            let config = SplitClientConfigHelper.fromMap(configurationMap: configValues, impressionListener: nil)
            XCTAssertEqual(expectedUserConsents[index], config.userConsent)
        }
    }

    func testImpressionsModeValuesAreMappedCorrectly() {
        let impressionsModes = ["debug", "none", "optimized"]
        let expectedImpressionsModes: [ImpressionsMode] = [.debug, .none, .optimized]

        for (index, impressionsMode) in impressionsModes.enumerated() {
            let configValues: [String: Any] = ["impressionsMode": impressionsMode]
            let config = SplitClientConfigHelper.fromMap(configurationMap: configValues, impressionListener: nil)
            XCTAssertEqual(expectedImpressionsModes[index].rawValue, config.impressionsMode)
        }
    }

    func testSyncConfigWithoutFlagSetsIsMappedCorrectly() {
        let configValues = [
            "syncConfig": ["syncConfigNames": ["split1", "split2"], "syncConfigPrefixes": ["split_", "my_split_"]],
        ]

        let splitClientConfig: SplitClientConfig = SplitClientConfigHelper.fromMap(configurationMap: configValues, impressionListener: nil)

        XCTAssertEqual(2, splitClientConfig.sync.filters.count)
        XCTAssertEqual(.byName, splitClientConfig.sync.filters[0].type)
        XCTAssertEqual(["split1", "split2"], splitClientConfig.sync.filters[0].values)
        XCTAssertEqual(.byPrefix, splitClientConfig.sync.filters[1].type)
        XCTAssertEqual(["split_", "my_split_"], splitClientConfig.sync.filters[1].values)
    }

    func testSyncConfigWithFlagSetsIsMappedCorrectly() {
        let configValues = [
            "syncConfig": ["syncConfigNames": ["split1", "split2"], "syncConfigPrefixes": ["split_", "my_split_"] , "syncConfigFlagSets": ["set_1", "set_2"]],
        ]

        let splitClientConfig: SplitClientConfig = SplitClientConfigHelper.fromMap(configurationMap: configValues, impressionListener: nil)

        XCTAssertEqual(1, splitClientConfig.sync.filters.count)
        XCTAssertEqual(.bySet, splitClientConfig.sync.filters[0].type)
        XCTAssertEqual(["set_1", "set_2"], splitClientConfig.sync.filters[0].values)
    }

    func testCertificatePinningConfigurationValuesAreMappedCorrectly() {
        let configValues = [
            "certificatePinningConfiguration": [
                "pins": [
                    "host1": [ "sha256/pin1", "sha1/pin2" ],
                    "host2": [ "sha256/pin2" ]
                ]
            ]
        ]

        let splitClientConfig: SplitClientConfig = SplitClientConfigHelper.fromMap(configurationMap: configValues, impressionListener: nil)
        let actualConfig = splitClientConfig.certificatePinningConfig!.pins

        let containsPins = actualConfig.contains { pin in
            (pin.host == "host1" && pin.algo == KeyHashAlgo.sha256) } &&
        actualConfig.contains { pin in
            (pin.host == "host1" && pin.algo == KeyHashAlgo.sha1) } &&
        actualConfig.contains { pin in
            (pin.host == "host2" && pin.algo == KeyHashAlgo.sha256 )
        }

        XCTAssertTrue(containsPins)
    }

    func testRolloutCacheConfigurationValuesAreMappedCorrectly() {
        let configValues = [
            "rolloutCacheConfiguration": [
                "expirationDays": 5,
                "clearOnInit": true
            ]
        ]

        let splitClientConfig: SplitClientConfig = SplitClientConfigHelper.fromMap(configurationMap: configValues, impressionListener: nil)
        let actualConfig = splitClientConfig.rolloutCacheConfiguration!

        XCTAssertEqual(5, actualConfig.expirationDays)
        XCTAssertTrue(actualConfig.clearOnInit)
    }
}
