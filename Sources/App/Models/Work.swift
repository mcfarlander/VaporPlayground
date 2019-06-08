//
//  Work.swift
//  App
//
//  Created by Dave Johnson on 3/10/19.
//

import Foundation
import FluentPostgreSQL
import Vapor

/// Work model, with parent of type Author.
/// Work is a PostgreSQL table in the Book database.
final class Work: Codable {
	
    var id: Int?
    var title: String
    var authorId: Author.ID
    
    init(id:Int? = nil, title:String, authorId:Author.ID) {
        self.id = id
        self.title = title
        self.authorId = authorId
    }
}

// MARK: - Work extends Model for PostgreSQL.
extension Work: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    static let idKey: IDKey = \Work.id
}

// MARK: - Work has a parent object of type Author.
extension Work {
    var author: Parent<Work, Author> {
        return parent(\.authorId)
    }
}

// MARK: - Work can validated.
extension Work: Validatable {
    /// See `Validatable`.
    static func validations() throws -> Validations<Work> {
        var validations = Validations(Work.self)
        // title must be at least 1 character
        try validations.add(\.title, .count(1...))
        return validations
    }
}

// Allows `Work` to be used as a dynamic migration. Adds the foreign key
extension Work: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { (builder) in
            try addProperties(to: builder)
            builder.reference(from: \.authorId, to: \Author.id)
        }
    }
}

/// Allows `Work` to be encoded to and decoded from HTTP messages.
extension Work: Content { }

/// Allows `Work` to be used as a dynamic parameter in route definitions.
extension Work: Parameter { }
