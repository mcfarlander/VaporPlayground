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

final class User: Codable {
	
    var id: Int?
    var username: String
    var password: String
	
	init(id:Int? = nil, username:String, password:String) {
		self.id = id
		self.username = username
		self.password = password
	}
}

extension User: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    static let idKey: IDKey = \User.id
}

extension User {
	var tokens: Children<User, UserToken> {
		return children(\.id)
	}
}

extension User: PasswordAuthenticatable {
	static var usernameKey: WritableKeyPath<User, String> {
		return \User.username
	}
	
	static var passwordKey: WritableKeyPath<User, String> {
		return \User.password
	}
}

extension User: TokenAuthenticatable {
	typealias TokenType = UserToken
}

// Allows `User` to be used as a dynamic migration.
extension User: Migration { }
/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content { }
/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }

struct PublicUser: Content {
	var username: String
	var token: String
}

/// Global - Use user model to create an authentication middleware
let tokenAuthMiddleware = User.tokenAuthMiddleware()
