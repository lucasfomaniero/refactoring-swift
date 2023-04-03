//
//  Types.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 02/04/23.
//

import Foundation

protocol Entity {
    
}

enum EntityType {
    
    case play
    case invoice
    case performance
    
    var type: any Entity.Type {
        switch self {
        case .play:
            return Play.self
        case .invoice:
            return Invoice.self
        case .performance:
            return Performance.self
        }
    }
}
