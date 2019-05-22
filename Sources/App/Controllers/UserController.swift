//
//  UserController.swift
//  App
//
//  Created by Dave Johnson on 4/13/19.
//

import Foundation
import Vapor
import Authentication

final class UserController: RouteCollection {
    
    func boot(router: Router) throws {
        let users = router.grouped("users")
        
		users.post("createUser", use: createUser)
		users.post("loginUser", use: loginUser)
        
    }
    
	func createUser(_ request: Request) throws -> Future<PublicUser> {
		return try request.content.decode(User.self).flatMap(to: PublicUser.self) { user in
			let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
			let newUser = User(username: user.username, password: passwordHashed)
			return newUser.save(on: request).flatMap(to: PublicUser.self) { createdUser in
				let accessToken = try UserToken.createToken(forUser: createdUser)
				return accessToken.save(on: request).map(to: PublicUser.self) { createdToken in
					let publicUser = PublicUser(username: createdUser.username, token: createdToken.token)
					return publicUser
				}
			}
		}
	}
	
	func loginUser(_ request: Request) throws -> Future<User> {
		return try request.content.decode(User.self).flatMap(to: User.self) { user in
			let passwordVerifier = try request.make(BCryptDigest.self)
			return User.authenticate(username: user.username, password: user.password, using: passwordVerifier, on: request).unwrap(or: Abort.init(HTTPResponseStatus.unauthorized)) 
		}
	}

}
