//
//  UserToken.swift
//  App
//
//  Created by Dave Johnson on 4/13/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

/// UserToken model, with parent of type User.
/// UserToken is a PostgreSQL table in the Book database.
final class UserToken: Codable {
	
	var id: Int?
	var token: String
	var userId: User.ID
	
	init(id:Int? = nil,token:String, userId: User.ID) {
		self.id = id
		self.token = token
		self.userId = userId
	}
	
}

// MARK: - UserToken extends Model for PostrgreSQL.
extension UserToken: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    static let idKey: IDKey = \UserToken.id
}

// MARK: - UserToken has a parent object of type User.
extension UserToken {
	var user: Parent<UserToken, User> {
		return parent(\.userId)
	}
}

// MARK: - Helper methods on UserToken for creating a token.
extension UserToken {
	
	/// Creates a new token for the user.
	///
	/// - Parameter user: the User being used for creation
	/// - Returns: the new UserToken generated
	/// - Throws: any error
	static func createToken(forUser user: User) throws -> UserToken {
		let tokenString = randomToken(withLength: 60)
		let newToken = try UserToken(token: tokenString, userId: user.requireID())
		return newToken
	}
	
	/// Method to generate a token of a certain size.
	///
	/// - Parameter length: the length of the token
	/// - Returns: the token of length defined
	private static func randomToken(withLength length: Int) -> String {
		let allowedChars = "$!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		let allowedCharsCount = UInt32(allowedChars.count)
		var randomString = ""
		for _ in 0..<length {
			let randomNumber = Int(arc4random_uniform(allowedCharsCount))
			let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNumber)
			let newCharacter = allowedChars[randomIndex]
			randomString += String(newCharacter)
		}
		return randomString
	}
}

// MARK: - UserToken can be used to authentication using the token.
extension UserToken: BearerAuthenticatable {
	static var tokenKey: WritableKeyPath<UserToken, String> {
		return \UserToken.token
	}
}

// MARK: - Definition of the token.
extension UserToken: Authentication.Token {
	static var userIDKey: WritableKeyPath<UserToken, Int> { return \UserToken.userId }
	typealias UserType = User
	typealias UserIDType = User.ID
}

// Allows `UserToken` to be used as a dynamic migration. Adds foreign key
extension UserToken: Migration {
	static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
		return Database.create(self, on: conn) { (builder) in
			try addProperties(to: builder)
			builder.reference(from: \.userId, to: \User.id)
		}
	}
}

