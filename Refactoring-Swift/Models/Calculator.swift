//
//  TragedyCalculator.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 06/04/23.
//

import Foundation

struct TragedyCalculator: PerformanceCalculator {
    var audience: Int
    
    var amount: Int {
        var result = 40000
        if audience > 30 {
            result += 1000 * (audience - 30)
        }
        return result
    }
    
}


struct ComedyCalculator: PerformanceCalculator {
    var audience: Int
    var amount: Int {
        var result = 30000
        if audience > 20 {
            result += 1000 + 500 * (audience - 20)
        }
        result += 300 * audience
        return result
    }
    
    var volumeCredits: Int {
        return max(audience - 30, 0) + audience / 5
    }
}
