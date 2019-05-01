//
//  WorkController.swift
//  App
//
//  Created by iMac 21inch on 3/12/19.
//

import Foundation
import Vapor

final class WorkController: RouteCollection {
    
    func boot(router: Router) throws {
        let works = router.grouped("works")
        
        works.get(use: list)
        works.get(Work.parameter, use: show)
        works.post(Work.self, use: create)
        works.put(Work.parameter, use: update)
        works.delete(Work.parameter, use: delete)
        
        works.get(Work.parameter, "author", use: getAuthor)

    }
    
    func list(_ request: Request) throws -> Future<[Work]> {
        return Work.query(on: request).all()
    }
    
    func show(_ request: Request) throws -> Future<Work> {
        return try request.parameters.next(Work.self)
    }
    
    func create(_ request: Request, work:Work) throws -> Future<Work> {
        return work.save(on: request)
    }
    
    func update(_ req: Request) throws -> Future<Work> {
        return try flatMap(to: Work.self, req.parameters.next(Work.self), req.content.decode(Work.self)) { (work, updatedWork) in
            work.title = updatedWork.title
            work.authorId = updatedWork.authorId
            return work.save(on: req)
        }
    }
    
    func delete(_ request: Request)throws -> Future<HTTPStatus> {
        return try request.parameters.next(Work.self).delete(on: request).transform(to: .noContent)
    }
    
    func getAuthor(_ req: Request) throws -> Future<Author> {
        return try req.parameters.next(Work.self).flatMap(to: Author.self) { (work) in
            return work.author.get(on: req)
        }
    }
    
}


