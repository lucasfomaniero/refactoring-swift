//
//  StatementData.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 05/04/23.
//

import Foundation

protocol IStatementData {
    var customer: String {get set}
    var performances: [PerformanceData] {get set}
}

typealias Catalog = [String : Play]


struct PerformanceData {
    let play: Play
    let audience: Int
    let amount: Int
    let volumeCredits: Int
    
    init(_ calculator: PerformanceCalculator, play: Play) {
        self.play = play
        self.audience = calculator.audience
        self.amount = calculator.amount
        self.volumeCredits = calculator.volumeCredits
    }
}

struct StatementData: IStatementData {
    
    var customer: String
    var performances: [PerformanceData]
    
    var totalVolumeCredits: Int {
        return  performances.reduce(into: 0) { result, performance in
            return result += performance.volumeCredits
        }
    }

    var totalAmount: Int {
           return performances.reduce(into: 0) {
               result, performance in
               return result += performance.amount
           }
    }

       init(invoice: Invoice, plays: Catalog) {

           func  playFor(_ performance: Performance) -> Play {
               guard let play = plays[performance.playID] else {
                   fatalError("Unknown play")
               }
               return play
           }

           customer = invoice.customer
           performances = invoice.performances.map {
               let calculator = StatementData.createPerformanceCalculator(performance: $0, play: playFor($0))
               return PerformanceData(calculator, play: playFor($0))
           }
       }
    
    static func createPerformanceCalculator(performance: Performance, play: Play) -> PerformanceCalculator {
            switch play.genre {
            case .tragedy:
                return TragedyCalculator(audience: performance.audience)
            case .comedy:
                return ComedyCalculator(audience: performance.audience)
            case .animation:
                return TragedyCalculator(audience: performance.audience)
            case .unknown:
                return TragedyCalculator(audience: performance.audience)
            }
        }
    
    
}
