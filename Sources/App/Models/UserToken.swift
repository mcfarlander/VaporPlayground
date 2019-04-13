//
//  UserToken.swift
//  App
//
//  Created by iMac 21inch on 4/13/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

struct UserToken: Codable {
    var id: Int?
    var string: String
    var userID: User.ID
    
    var user: Parent<UserToken, User> {
        return parent(\.userID)
    }
}

extension UserToken: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    static let idKey: IDKey = \UserToken.id
}

// Allows `UserToken` to be used as a dynamic migration.
extension UserToken: Migration { }

extension UserToken: Token {
    /// See `Token`.
    typealias UserType = User
    
    /// See `Token`.
    static var tokenKey: WritableKeyPath<UserToken, String> {
        return \.string
    }
    
    /// See `Token`.
    static var userIDKey: WritableKeyPath<UserToken, User.ID> {
        return \.userID
    }
}
