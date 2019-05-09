//
//  Work.swift
//  App
//
//  Created by iMac 21inch on 3/10/19.
//

import Foundation
import FluentPostgreSQL
import Vapor

/// Work model, with parent of type Author.
/// Work is a PostgreSQL table in the Book database.
final class Work: Codable {
    var workId: Int?
    var title: String
    var authorId: Author.ID
    
    var createdAt: Date?
    var updatedAt: Date?
    
    init(workId:Int? = nil, title:String, authorId:Author.ID) {
        self.workId = workId
        self.title = title
        self.authorId = authorId
        self.createdAt = Date()
        self.updatedAt = Date()
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

extension Work: Validatable {
    /// See `Validatable`.
    static func validations() throws -> Validations<Work> {
        var validations = Validations(Work.self)
        // title must be at least 1 character
        try validations.add(\.title, .count(1...))
        return validations
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
