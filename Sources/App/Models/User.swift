//
//  User.swift
//  App
//
//  Created by iMac 21inch on 4/13/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

struct User: Codable {
    var id: Int?
    var name: String
    var email: String
    var passwordHash: String
    
    var tokens: Children<User, UserToken> {
        return children(\.userID)
    }
}

extension User: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    static let idKey: IDKey = \User.id
}

// Allows `User` to be used as a dynamic migration.
extension User: Migration { }
/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content { }
/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }

extension User: TokenAuthenticatable {
    /// See `TokenAuthenticatable`.
    typealias TokenType = UserToken
}

struct UserContent: Content {
    var name: String?
    var email: String?
}
