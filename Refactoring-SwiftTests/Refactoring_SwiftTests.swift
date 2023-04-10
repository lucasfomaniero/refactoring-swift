//
//  Refactoring_SwiftTests.swift
//  Refactoring-SwiftTests
//
//  Created by Lucas Maniero on 30/03/23.
//

import XCTest
@testable import Refactoring_Swift

final class Refactoring_SwiftTests: XCTestCase {
    
    var invoices: [Invoice] = [
        Invoice(customer: "BigCo", performances: [
            .init(playID: "hamlet", audience: 55),
            .init(playID: "as-like", audience: 35),
            .init(playID: "othello", audience: 40)
        ]),
        Invoice(customer: "Lucas Maniero", performances: [
            .init(playID: "hamlet", audience: 70),
            .init(playID: "as-like", audience: 10),
            .init(playID: "othello", audience: 100)
        ])
    ]
    
    var plays: [String:Play] = [
        "hamlet": .init(name: "Hamlet", type: "tragedy"),
        "as-like": .init(name: "As You Like It", type: "comedy"),
        "othello": .init(name: "Othello", type: "tragedy"),
        "miserables": .init(name: "Los miserables", type: "tragedy"),
        "mulan": .init(name: "Mulan", type: "animation")
    ]

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
    
    func testComedyCalculations() throws {
        //Uses the invoice for BigCo and the play As You Like
        let comedyPerfWithAudienceAbove20 = Performance(playID: "as-like", audience: 21)
        let amountForAudienceAbove20 = try fileUtils.amountFor(comedyPerfWithAudienceAbove20)
        XCTAssertEqual(amountForAudienceAbove20, 37800)
        
        let comedyPerformanceBelowOrEqualTo20 = Performance(playID: "as-like", audience: 1)
        let amountForPerformanceBelow20 = try fileUtils.amountFor(comedyPerformanceBelowOrEqualTo20)
        XCTAssertEqual(amountForPerformanceBelow20, 30300)
    }
    
    func testTragedyCalculations() throws {
        let tragedyPerfWithAudienceAbove30 = Performance(playID: "hamlet", audience: 31)
        let amountForAudienceAbove30 = try fileUtils.amountFor(tragedyPerfWithAudienceAbove30)
        XCTAssertEqual(amountForAudienceAbove30, 41000)
        
        let comedyPerformanceBelowOrEqualTo30 = Performance(playID: "hamlet", audience: 1)
        let amountForPerformanceBelow30 = try fileUtils.amountFor(comedyPerformanceBelowOrEqualTo30)
        XCTAssertEqual(amountForPerformanceBelow30, 40_000)
    }
    
    
    func testCorrectStringCalculation() throws {
        fileUtils.renderContent(type: .plain, data: .init(invoice: invoices[0], plays: plays))
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
        fileUtils.renderContent(type: .html, data: .init(invoice: invoices[0], plays: plays))
        let html = "<h1>Statement for BigCo</h1><table><tr><th>play</th><th>seats</th><th>cost</th></tr><tr><td>Hamlet</td><td>55</td><td>$650.00</td></tr><tr><td>As You Like It</td><td>35</td><td>$490.00</td></tr><tr><td>Othello</td><td>40</td><td>$500.00</td></tr></table><p>Amount owed is <em>$1,640.00</em></p><p>You earned <em>47</em> credits</p>"
        
        print(html.difference(from: fileUtils.result[0]))
        XCTAssertEqual(html, fileUtils.result[0])
    }

}
