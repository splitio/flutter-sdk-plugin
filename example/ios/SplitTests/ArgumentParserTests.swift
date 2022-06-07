//
//  ArgumentParserTests.swift
//  ArgumentParserTests
//
//  Created by Gaston Thea on 07/06/2022.
//

import XCTest
@testable import splitio

class ArgumentParserTests: XCTestCase {

    private var argumentParser: ArgumentParser?

    override func setUpWithError() throws {
        argumentParser = DefaultArgumentParser()
    }

    func testGetStringArgument() throws {
        let arguments: [String: Any?] = ["apiKey": "api-key", "booleanValue": true]
        let stringArgument = argumentParser?.getStringArgument(argumentName: "apiKey", arguments: arguments)
        
        XCTAssert(stringArgument == "api-key")
    }
    
    func testGetStringArgumentFailure() throws {
        let arguments: [String: Any?] = ["apiKey": "api-key", "booleanValue": true]
        let stringArgument = argumentParser?.getStringArgument(argumentName: "booleanValue", arguments: arguments)
        
        XCTAssert(stringArgument == nil)
    }

    func testGetBooleanArgument() throws {
        let arguments: [String: Any?] = ["apiKey": "api-key", "booleanValue": true]

        let booleanValue = argumentParser?.getBooleanArgument(argumentName: "booleanValue", arguments: arguments)

        XCTAssert(booleanValue == true)
    }
    
    func testGetBooleanArgumentFailure() throws {
        let arguments: [String: Any?] = ["apiKey": "api-key", "booleanValue": 25]

        let booleanValue = argumentParser?.getBooleanArgument(argumentName: "booleanValue", arguments: arguments)

        XCTAssert(booleanValue == false)
    }
}
