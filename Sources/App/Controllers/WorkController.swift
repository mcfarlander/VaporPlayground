//
//  WorkController.swift
//  App
//
//  Created by Dave Johnson on 3/12/19.
//

import Foundation
import Vapor

/// WorkController is the controller of the Work ORM via HTTP verbs.
final class WorkController: RouteCollection {
    
    /// Define the routes for the Work ORM.
    ///
    /// - Parameter router: the application router
    /// - Throws: any error when defining the routes
    func boot(router: Router) throws {
        let works = router.grouped("works")
        
        works.get(use: list)
        works.get(Work.parameter, use: show)
        works.post(Work.self, use: create)
        works.put(Work.parameter, use: update)
        works.delete(Work.parameter, use: delete)
        
        works.get(Work.parameter, "author", use: getAuthor)

    }
    
    /// Get list all works: /works.
    ///
    /// - Parameter request: the request
    /// - Returns: array of Work objects
    /// - Throws: any error
    func list(_ request: Request) throws -> Future<[Work]> {
        return Work.query(on: request).all()
    }
    
    /// Get a specific work: /works/1, etc.
    ///
    /// - Parameter request: the request
    /// - Returns: the specific work
    /// - Throws: any error
    func show(_ request: Request) throws -> Future<Work> {
        return try request.parameters.next(Work.self)
    }
    
    /// Post work to the ORM.
    ///
    /// - Parameters:
    ///   - request: the request
    ///   - author: the request body work
    /// - Returns: the work from the ORM
    /// - Throws: any error
    func create(_ request: Request, work:Work) throws -> Future<Work> {
        return work.save(on: request)
    }
    
    /// Put an work to the ORM.
    ///
    /// - Parameters:
    ///   - request: the request
    ///   - body: the request body work to update
    /// - Returns: the updated work from the ORM
    /// - Throws: any error
    func update(_ req: Request) throws -> Future<Work> {
        return try flatMap(to: Work.self, req.parameters.next(Work.self), req.content.decode(Work.self)) { (work, updatedWork) in
            work.title = updatedWork.title
            work.authorId = updatedWork.authorId
            return work.save(on: req)
        }
    }
    
    /// Delete a work from the ORM.
    ///
    /// - Parameter request: the request with the work id as the parameter
    /// - Returns: HTTP status 200
    /// - Throws: any error
    func delete(_ request: Request)throws -> Future<HTTPStatus> {
        return try request.parameters.next(Work.self).delete(on: request).transform(to: .noContent)
    }
    
    /// Get the author from the given work: /works/1/author.
    ///
    /// - Parameter req: the request
    /// - Returns: the author from the ORM
    /// - Throws: any error
    func getAuthor(_ req: Request) throws -> Future<Author> {
        return try req.parameters.next(Work.self).flatMap(to: Author.self) { (work) in
            return work.author.get(on: req)
        }
    }
    
}


