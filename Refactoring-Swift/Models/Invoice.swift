//
//  Invoice.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 30/03/23.
//

import Foundation

struct Invoice: Codable, Entity {
    var customer: String
    var performances: [Performance]
}
