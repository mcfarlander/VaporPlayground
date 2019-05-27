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

extension UserToken: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    static let idKey: IDKey = \UserToken.id
}

extension UserToken {
	var user: Parent<UserToken, User> {
		return parent(\.userId)
	}
}

extension UserToken {
	
	static func createToken(forUser user: User) throws -> UserToken {
		let tokenString = randomToken(withLength: 60)
		let newToken = try UserToken(token: tokenString, userId: user.requireID())
		return newToken
	}
	
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

extension UserToken: BearerAuthenticatable {
	static var tokenKey: WritableKeyPath<UserToken, String> {
		return \UserToken.token
	}
}

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

