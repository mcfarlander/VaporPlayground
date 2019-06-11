//
//  UserController.swift
//  App
//
//  Created by Dave Johnson on 4/13/19.
//

import Foundation
import Vapor
import Authentication

/// User controller for creating a user and logging in.
final class UserController: RouteCollection {
    
    func boot(router: Router) throws {
        let users = router.grouped("users")
        
		users.post("create", use: create)
		users.post("login", use: login)
		users.post("loginWithCreds", use: loginWithCreds)
        
    }
    
	/// Create a user.
	///
	/// - Parameter request: the request
	/// - Returns: a future containing a PublicUser content
	/// - Throws: any error
	func create(_ request: Request) throws -> Future<PublicUser> {
		return try request.content.decode(User.self).flatMap(to: PublicUser.self) { user in
			try user.validate()
			let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
			let newUser = User(username: user.username, password: passwordHashed)
			return newUser.save(on: request).flatMap(to: PublicUser.self) { createdUser in
				let accessToken = try UserToken.createToken(forUser: createdUser)
				return accessToken.save(on: request).map(to: PublicUser.self) { createdToken in
					let publicUser = PublicUser(username: createdUser.username, token: createdToken.token, expires: createdToken.expires)
					return publicUser
				}
			}
		}
	}
	
	/// Log into the service to get the user's name and authorization token.
	///
	/// - Parameter request: the request
	/// - Returns: a future containing the public user
	/// - Throws: any error
	func login(_ request: Request) throws -> Future<PublicUser> {
		
		// decode the request to a user object
		return try request.content.decode(User.self).flatMap(to: PublicUser.self) { user in
			let passwordVerifier = try request.make(BCryptDigest.self)
			// authenticate on the user name and pasword
			return User.authenticate(username: user.username, password: user.password, using: passwordVerifier, on: request).unwrap(or: Abort.init(HTTPResponseStatus.unauthorized)).flatMap(to: PublicUser.self) {authorized in
				// if authenticated get the first token for the this user and return the public user object
				// when checking against the expires token, use all() rather than first() and loop through values
				// if not found, then return unauthorized
				return try authorized.tokens.query(on: request).first().map(to: PublicUser.self) {usertoken in
					return PublicUser(username: user.username, token: usertoken!.token, expires: usertoken!.expires)
				}
			}
		}
		
	}
	
	/// Log into the service to get the user user name and encrypted password.
	///
	/// - Parameter request: the request
	/// - Returns: a future containing the user
	/// - Throws: any error
	func loginWithCreds(_ request: Request) throws -> Future<User> {
		return try request.content.decode(User.self).flatMap(to: User.self) { user in
			let passwordVerifier = try request.make(BCryptDigest.self)
			return User.authenticate(username: user.username, password: user.password, using: passwordVerifier, on: request).unwrap(or: Abort.init(HTTPResponseStatus.unauthorized))
		}
	}
	

}
