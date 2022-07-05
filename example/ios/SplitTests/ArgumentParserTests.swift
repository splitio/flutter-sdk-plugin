import XCTest
@testable import splitio

class ArgumentParserTests: XCTestCase {

    private var argumentParser: ArgumentParser?

    override func setUpWithError() throws {
        argumentParser = DefaultArgumentParser()
    }

    func testGetStringArgument() throws {
        let arguments: [String: Any?] = ["apiKey": "api-key", "booleanValue": true]
        let stringArgument = argumentParser?.getStringArgument(argumentName: Argument.apiKey, arguments: arguments)

        XCTAssert(stringArgument == "api-key")
    }

    func testGetStringArgumentFailure() throws {
        let arguments: [String: Any?] = ["apiKey": "api-key", "matchingKey": true]
        let stringArgument = argumentParser?.getStringArgument(argumentName: Argument.matchingKey, arguments: arguments)

        XCTAssert(stringArgument == nil)
    }

    func testGetMapArgument() throws {
        let dictArgument: [String: Any?] = ["key": "value", "key2": true]
        let arguments: [String: Any?] = ["apiKey": "api-key", "matchingKey": dictArgument]
        let mapArgument: [String: Any?] = argumentParser?.getMapArgument(argumentName: Argument.matchingKey, arguments: arguments) ?? [:]

        XCTAssert(NSDictionary(dictionary: mapArgument).isEqual(to: dictArgument))
    }

    func testGetMapArgumentFailure() throws {
        let arguments: [String: Any?] = ["apiKey": "api-key", "matchingKey": false]
        let mapArgument = argumentParser?.getMapArgument(argumentName: Argument.matchingKey, arguments: arguments) ?? [:]

        XCTAssert(NSDictionary(dictionary: mapArgument).isEqual(to: [:]))
    }

    func testGetBooleanArgument() throws {
        let arguments: [String: Any?] = ["apiKey": "api-key", "matchingKey": true]

        let booleanValue = argumentParser?.getBooleanArgument(argumentName: Argument.matchingKey, arguments: arguments)

        XCTAssert(booleanValue == true)
    }

    func testGetBooleanArgumentFailure() throws {
        let arguments: [String: Any?] = ["apiKey": "api-key", "matchingKey": 25]

        let booleanValue = argumentParser?.getBooleanArgument(argumentName: Argument.matchingKey, arguments: arguments)

        XCTAssert(booleanValue == false)
    }
}
