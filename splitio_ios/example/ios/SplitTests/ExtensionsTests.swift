import XCTest
import Split
@testable import splitio_ios

class ExtensionsTests: XCTestCase {

    func testImpressionMapping() throws {
        var impression = Impression()
        impression.keyName = "matching-key"
        impression.feature = "my-split"
        impression.changeNumber = 121212
        impression.bucketingKey = "bucketing-key"
        impression.attributes = ["age": 25, "name": "John"]
        impression.label = "label"
        impression.treatment = "on"
        impression.time = 16161616

        let impressionMap = impression.toMap()
        XCTAssert(impressionMap.count == 9)
        XCTAssert(NSDictionary(dictionary: impressionMap).isEqual(to: [
            "key": "matching-key",
            "bucketingKey": "bucketing-key",
            "changeNumber": 121212,
            "attributes": ["age": 25, "name": "John"],
            "appliedRule": "label",
            "treatment": "on",
            "split": "my-split",
            "time": 16161616,
            "properties": "{}"]))
    }

    func testSplitViewMapping() throws {
        var splitView = SplitView()
        splitView.name = "my-split"
        splitView.trafficType = "account"
        splitView.killed = true
        splitView.treatments = ["on", "off"]
        splitView.changeNumber = 121212
        splitView.configs = ["key": "value"]
        splitView.defaultTreatment = "off"
        splitView.sets = ["set1", "set2"]
        splitView.impressionsDisabled = true

        let splitViewMap = SplitView.asMap(splitView: splitView)
        
        // Debug: Print actual values
        print("DEBUG - SplitView map count: \(splitViewMap.count)")
        print("DEBUG - SplitView map: \(splitViewMap)")
        
        XCTAssert(splitViewMap.count == 10)
        XCTAssert(NSDictionary(dictionary: splitViewMap).isEqual(to: [
            "name": "my-split",
            "trafficType": "account",
            "killed": true,
            "treatments": ["on", "off"],
            "changeNumber": 121212,
            "configs": ["key": "value"],
            "defaultTreatment": "off",
            "sets": ["set1", "set2"],
            "impressionsDisabled": true,
            "prerequisites": []]))
    }
    
    func testImpressionMappingDebug() throws {
        var impression = Impression()
        impression.keyName = "matching-key"
        impression.feature = "my-split"
        impression.changeNumber = 121212
        impression.bucketingKey = "bucketing-key"
        impression.attributes = ["age": 25, "name": "John"]
        impression.label = "label"
        impression.treatment = "on"
        impression.time = 16161616

        let impressionMap = impression.toMap()
        
        // Debug: Print actual values
        print("DEBUG - Impression map count: \(impressionMap.count)")
        print("DEBUG - Impression map: \(impressionMap)")
    }
}
