//
//  Errors.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 30/03/23.
//

import Foundation

enum Errors: Error {
    case unknownTypeError(message: String)
    case errorWhileConvertingHTMLtoAttributedString(message: String)
}
