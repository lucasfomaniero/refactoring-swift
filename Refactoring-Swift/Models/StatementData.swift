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

class StatementData: IStatementData {
    var customer: String
    var performances: [Performance]
    var invoice: Invoice
    
    init(customer: String = "", performances: [Performance] = [], invoice: Invoice) {
        self.customer = customer
        self.performances = performances
        self.invoice = invoice
    }
}
