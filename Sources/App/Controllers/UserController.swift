//
//  UserController.swift
//  App
//
//  Created by iMac 21inch on 4/13/19.
//

import Foundation
import Vapor

final class UserController: RouteCollection {
    
    func boot(router: Router) throws {
        let users = router.grouped("users")
        
        users.get(use: list)
        users.get(User.parameter, use: show)
        users.post(User.self, use: create)
        users.patch(UserContent.self, at: User.parameter, use: update)
        users.delete(User.parameter, use: delete)
        
    }
    
    func list(_ request: Request) throws -> Future<[User]> {
        return User.query(on: request).all()
    }
    
    func show(_ request: Request) throws -> Future<User> {
        return try request.parameters.next(User.self)
    }
    
    func create(_ request: Request, user:User) throws -> Future<User> {
        return user.save(on: request)
    }
    
    func update(_ request: Request, _ body: UserContent)throws -> Future<User> {
        let user = try request.parameters.next(User.self)
        return user.map(to: User.self, { user in
            //user.name = body.name ?? user.name
            //user.email = body.email ?? user.email
            return user
        }).update(on: request)
    }
    
    func delete(_ request: Request)throws -> Future<HTTPStatus> {
        return try request.parameters.next(User.self).delete(on: request).transform(to: .noContent)
    }

}
