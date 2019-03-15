//
//  Work.swift
//  App
//
//  Created by iMac 21inch on 3/10/19.
//

import Foundation
import FluentPostgreSQL
import Vapor

final class Work: Codable {
    var workId: Int?
    var title: String
    var authorId: Author.ID
    
    init(workId:Int? = nil, title:String, authorId:Author.ID) {
        self.workId = workId
        self.title = title
        self.authorId = authorId
    }
}

extension Work: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    static let idKey: IDKey = \Work.workId
}

extension Work {
    var author: Parent<Work, Author> {
        return parent(\.authorId)
    }
}

// Allows `Work` to be used as a dynamic migration.
extension Work: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { (builder) in
            try addProperties(to: builder)
            builder.reference(from: \.authorId, to: \Author.authorId)
        }
    }
    
}

/// Allows `Work` to be encoded to and decoded from HTTP messages.
extension Work: Content { }

/// Allows `Work` to be used as a dynamic parameter in route definitions.
extension Work: Parameter { }
