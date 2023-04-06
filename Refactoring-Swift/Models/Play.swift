//
//  Play.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 30/03/23.
//

import Foundation

struct Play: Codable, Entity {
    var id: String?
    var name: String
    var type: String
    var genre: Genre {
        return Genre.allCases.first {$0.rawValue == type} ?? .unknown
    }
    
    enum Genre:String, Codable, CaseIterable {
        case comedy = "comedy"
        case tragedy = "tragedy"
        case animation = "animation"
        case unknown = "unknown"
    }
}
