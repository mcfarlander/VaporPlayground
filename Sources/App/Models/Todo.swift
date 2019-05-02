//
//  Todo.swift
//  App
//
//  Created by iMac 21inch on 5/1/19.
//

import Foundation
import Vapor

struct Todo: Codable {
    var userId:Int
    var id:Int
    var title:String
    var completed:Bool
}

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter {
    
    static func resolveParameter(_ parameter: String, on container: Container) throws -> Int {
        return Int(parameter)!
    }
    
    typealias ResolvedParameter = Int
}
