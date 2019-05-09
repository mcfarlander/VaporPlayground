//
//  Todo.swift
//  App
//
//  Created by iMac 21inch on 5/1/19.
//

import Foundation
import Vapor

/// Todo model. This model is used to interact with the remote web service
/// defined in the TodoController controller.
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
