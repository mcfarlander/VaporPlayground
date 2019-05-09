//
//  UserController.swift
//  App
//
//  Created by Dave Johnson on 4/13/19.
//

import Foundation
import Vapor

final class UserController: RouteCollection {
    
    func boot(router: Router) throws {
        let users = router.grouped("users")
        
        users.get(use: list)
        users.get(User.parameter, use: show)
        users.post(User.self, use: create)
        users.put(User.parameter, use: update)
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
    
    func update(_ req: Request) throws -> Future<User> {
        return try flatMap(to: User.self, req.parameters.next(User.self), req.content.decode(User.self)) { (user, updatedUser) in
            user.name = updatedUser.name
            user.email = updatedUser.email
            return user.save(on: req)
        }
    }
    
    func delete(_ request: Request)throws -> Future<HTTPStatus> {
        return try request.parameters.next(User.self).delete(on: request).transform(to: .noContent)
    }

}
