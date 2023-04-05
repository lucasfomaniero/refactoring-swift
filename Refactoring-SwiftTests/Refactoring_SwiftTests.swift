//
//  Refactoring_SwiftTests.swift
//  Refactoring-SwiftTests
//
//  Created by Lucas Maniero on 30/03/23.
//

import XCTest
@testable import Refactoring_Swift

final class Refactoring_SwiftTests: XCTestCase {

    private var fileUtils: FileUtil!
    private var plays: [String: Play]!
    private var invoices: [Invoice]!
    
    override func setUpWithError() throws {
        fileUtils = FileUtil()
        plays = fileUtils.loadDictionary(ofType: Play.self, ofFileWithName: "plays.json")
        invoices = fileUtils.loadItems(ofType: Invoice.self, ofFileWithName: "invoices.json")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIfJSONFilesAreFetchedCorrectly() throws {
        XCTAssertNotNil(plays)
        XCTAssertNotNil(invoices)
    }
    
    func testCorrectStringCalculation() throws {
        let text = """
        Statement for BigCo
        |-Hamlet: 650.00 (55 seats)
        |-As You Like It: 580.00 (35 seats)
        |-Othello: 500.00 (40 seats)
        Amount owed is 1,730.00
        Your earned 47.0 credit
        """
        
        XCTAssertEqual(text, fileUtils.result[0])
    }

}
