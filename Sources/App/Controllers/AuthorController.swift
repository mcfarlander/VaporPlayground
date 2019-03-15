//
//  AuthorsController.swift
//  App
//
//  Created by iMac 21inch on 3/2/19.
//
import Foundation
import Vapor

final class AuthorController: RouteCollection {
    
    func boot(router: Router) throws {
        let authors = router.grouped("authors")
    
        authors.get(use: list)
        authors.get(Author.parameter, use: show)
        authors.post(Author.self, use: create)
        authors.patch(AuthorContent.self, at: Author.parameter, use: update)
        authors.delete(Author.parameter, use: delete)
        
        authors.get(Author.parameter, "works", use: getWorks)
        
    }
    
    func list(_ request: Request) throws -> Future<[Author]> {
        return Author.query(on: request).all()
    }
    
    func show(_ request: Request) throws -> Future<Author> {
        return try request.parameters.next(Author.self)
    }
    
    func create(_ request: Request, author:Author) throws -> Future<Author> {
        return author.save(on: request)
    }
    
    func update(_ request: Request, _ body: AuthorContent)throws -> Future<Author> {
        let author = try request.parameters.next(Author.self)
        return author.map(to: Author.self, { author in
            author.firstName = body.firstName ?? author.firstName
            author.lastName = body.lastName ?? author.lastName
            return author
        }).update(on: request)
    }
    
    func delete(_ request: Request)throws -> Future<HTTPStatus> {
        return try request.parameters.next(Author.self).delete(on: request).transform(to: .noContent)
    }
    
    func getWorks(_ req: Request) throws -> Future<[Work]> {
        return try req.parameters.next(Author.self).flatMap(to: [Work].self) { (author) in
            return try author.works.query(on: req).all()
        }
    }
    
}

struct AuthorContent:Content {
    var firstName: String?
    var lastName: String?
}

struct AuthorView: Encodable {
    var author: Author
    var works: Future<[Work]>
}
