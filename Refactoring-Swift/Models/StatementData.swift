//
//  StatementData.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 05/04/23.
//

import Foundation

protocol IStatementData {
    var customer: String {get set}
    var performances: [Performance] {get set}
    var invoice: Invoice {get set}
}

struct StatementData: IStatementData {
    var customer: String
    var performances: [Performance]
    var invoice: Invoice
    
//    struct PerformanceData {
//        let play: Play
//        let audience: Int
//        let amount: Int
//        let volumeCredits: Int
//
//    }
}
