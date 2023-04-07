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
    
    override func setUpWithError() throws {
        fileUtils = FileUtil()
        fileUtils.loadFiles()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIfJSONFilesAreFetchedCorrectly() throws {
        XCTAssertGreaterThan(fileUtils.plays.count, 0)
        XCTAssertGreaterThan(fileUtils.invoices.count, 0)
    }
    
    func testCorrectStringCalculation() throws {
        fileUtils.getPlainContent()
        let text = """
        Statement for BigCo
        |-Hamlet: $650.00 (55 seats)
        |-As You Like It: $490.00 (35 seats)
        |-Othello: $500.00 (40 seats)
        Amount owed is $1,640.00
        Your earned 47 credit
        """
        XCTAssertEqual(text, fileUtils.result[0])
    }
    
    func testHTMLGeneration() {
        fileUtils.getHTMLContent()
        let html = """
        <h1>Statement for BigCo</h1>
        <table>
        <tr><th>play</th><th>seats</th><th>cost</th></tr>
        <tr><td>Hamlet</td><td>55</td><td>$650.00</td></tr>
        <tr><td>As You Like It</td><td>35</td><td>$490.00</td></tr>
        <tr><td>Othello</td><td>40</td><td>$500.00</td></tr>
        </table>
        <p>Amount owed is <em>$1,640.00</em></p>
        <p>You earned <em>47</em> credits</p>
        """
        
        XCTAssertEqual(html, fileUtils.result[0])
    }

}
