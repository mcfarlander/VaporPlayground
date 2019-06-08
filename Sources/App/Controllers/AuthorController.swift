//
//  AuthorsController.swift
//  App
//
//  Created by Dave Johnson on 3/2/19.
//
import Foundation
import Vapor

/// AuthorController is the controller of the Author ORM via HTTP verbs.
final class AuthorController: RouteCollection {
    
    /// Define the routes for the Author ORM.
    ///
    /// - Parameter router: the application router
    /// - Throws: any error when defining the routes
    func boot(router: Router) throws {
		
        let authors = router.grouped(tokenAuthMiddleware).grouped("authors")
    
        authors.get(use: list)
        authors.get(Author.parameter, use: show)
        authors.post(Author.self, use: create)
        authors.patch(AuthorContent.self, at: Author.parameter, use: update)
        authors.delete(Author.parameter, use: delete)
        
        authors.get(Author.parameter, "works", use: getWorks)
        
    }
    
    /// Get list all authors: /authors.
    ///
    /// - Parameter request: the request
    /// - Returns: array of Author objects
    /// - Throws: any error
    func list(_ request: Request) throws -> Future<[Author]> {
		_ = try request.requireAuthenticated(User.self)
        return Author.query(on: request).all()
    }
    
    /// Get a specific author: /authors/1, etc.
    ///
    /// - Parameter request: the request
    /// - Returns: the specific author
    /// - Throws: any error
    func show(_ request: Request) throws -> Future<Author> {
		_ = try request.requireAuthenticated(User.self)
        return try request.parameters.next(Author.self)
    }
    
    /// Post an author to the ORM.
    ///
    /// - Parameters:
    ///   - request: the request
    ///   - author: the request body author
    /// - Returns: the author from the ORM
    /// - Throws: any error
    func create(_ request: Request, author:Author) throws -> Future<Author> {
		
		_ = try request.requireAuthenticated(User.self)
		
		return try request.content.decode(Author.self).flatMap(to: Author.self) { author in
			try author.validate()
			let newAuthor = Author(firstName: author.firstName, lastName: author.lastName)
			return newAuthor.save(on: request)
		}
    }
    
    /// Put an author to the ORM.
    /// 
    /// - Parameters:
    ///   - request: the request
    ///   - body: the request body author to update
    /// - Returns: the updated author from the ORM
    /// - Throws: any error
    func update(_ request: Request, _ body: AuthorContent)throws -> Future<Author> {
		_ = try request.requireAuthenticated(User.self)
        let author = try request.parameters.next(Author.self)
        return author.map(to: Author.self, { author in
            author.firstName = body.firstName ?? author.firstName
            author.lastName = body.lastName ?? author.lastName
            return author
        }).update(on: request)
    }
    
    /// Delete an author from the ORM.
    ///
    /// - Parameter request: the request with the author id as the parameter
    /// - Returns: HTTP status 200
    /// - Throws: any error
    func delete(_ request: Request)throws -> Future<HTTPStatus> {
		_ = try request.requireAuthenticated(User.self)
        return try request.parameters.next(Author.self).delete(on: request).transform(to: .noContent)
    }
    
    /// Get a list of Work objects related to this author.
    ///
    /// - Parameter request: the request
    /// - Returns: a list of work objects from the ORM
    /// - Throws: any error
    func getWorks(_ request: Request) throws -> Future<[Work]> {
		_ = try request.requireAuthenticated(User.self)
        return try request.parameters.next(Author.self).flatMap(to: [Work].self) { (author) in
            return try author.works.query(on: request).all()
        }
    }
    
}

/// AuthorContent model (used for the PUT).
struct AuthorContent:Content {
    var firstName: String?
    var lastName: String?
}


/// The author and works view model.
struct AuthorView: Encodable {
    var author: Author
    var works: Future<[Work]>
}
