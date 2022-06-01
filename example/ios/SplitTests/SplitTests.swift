//
//  SplitTests.swift
//  SplitTests
//
//  Created by Gaston Thea on 01/06/2022.
//

import XCTest
@testable import splitio
@testable import Split

class SplitTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class SplitFactoryProviderStub : SplitFactoryProvider {
    
    func getFactory() -> SplitFactory? {
        return nil
    }
}
