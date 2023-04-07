//
//  PerformanceCalculator.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 06/04/23.
//

import Foundation

protocol PerformanceCalculator {
    var audience: Int { get }
    var amount: Int { get }
    var volumeCredits: Int { get }
}

extension PerformanceCalculator {
    var volumeCredits: Int {
        return max(audience - 30, 0)
    }
}
