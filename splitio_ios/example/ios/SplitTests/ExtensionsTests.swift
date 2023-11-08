import XCTest
import Split

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
        XCTAssert(impressionMap.count == 8)
        XCTAssert(NSDictionary(dictionary: impressionMap).isEqual(to: [
            "key": "matching-key",
            "bucketingKey": "bucketing-key",
            "changeNumber": 121212,
            "attributes": ["age": 25, "name": "John"],
            "appliedRule": "label",
            "treatment": "on",
            "split": "my-split",
            "time": 16161616]))
    }
}
