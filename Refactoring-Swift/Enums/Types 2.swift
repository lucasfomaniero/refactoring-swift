//
//  Types.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 02/04/23.
//

import Foundation

<<<<<<< Updated upstream
protocol Entity: Decodable {
    
}

=======
>>>>>>> Stashed changes
enum EntityType {
    
    case play
    case invoice
    case performance
    
<<<<<<< Updated upstream
    var name: any Entity.Type {
=======
    var type: Any.Type {
>>>>>>> Stashed changes
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
