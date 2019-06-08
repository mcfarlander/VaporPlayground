//
//  User.swift
//  App
//
//  Created by Dave Johnson on 4/13/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

/// User model, with children of type UserToken.
/// User is a PostgreSQL table in the Book database.
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

// MARK: - User extends Model for PostgreSQL.
extension User: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    static let idKey: IDKey = \User.id
}

// MARK: - User has child objects of type UserToken.
extension User {
	var tokens: Children<User, UserToken> {
		return children(\.id)
	}
}

// MARK: - User can validated.
extension User: Validatable {
	/// See `Validatable`.
	static func validations() throws -> Validations<User> {
		var validations = Validations(User.self)
		try validations.add(\.username, .count(1...))
		try validations.add(\.password, .count(1...))
		return validations
	}
}

// MARK: - User can be used to authenticate on username and password.
extension User: PasswordAuthenticatable {
	static var usernameKey: WritableKeyPath<User, String> {
		return \User.username
	}
	
	static var passwordKey: WritableKeyPath<User, String> {
		return \User.password
	}
}

// MARK: - User can be authenticated on the user's token.
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
