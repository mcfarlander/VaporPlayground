//
//  Authors.swift
//  App
//
//  Created by Dave Johnson  on 3/2/19.
//

import Foundation
import FluentPostgreSQL
import Vapor

/// Author model, with children of type Work.
/// Author is a PostgreSQL table in the Book database.
final class Author:Codable {
    var authorId: Int?
    var firstName: String
    var lastName: String
    
    init(authorId:Int? = nil, firstName:String, lastName:String) {
        self.authorId = authorId
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension Author: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    static let idKey: IDKey = \Author.authorId
}

extension Author {
    var works: Children<Author, Work> {
        return children(\.authorId)
    }
}

extension Author: Validatable {
    /// See `Validatable`.
    static func validations() throws -> Validations<Author> {
        var validations = Validations(Author.self)
        // first name must be at least 1 character
        try validations.add(\.firstName, .count(1...))
        // last name must be at least 1 character
        try validations.add(\.lastName, .count(1...))
        return validations
    }
}

// Allows `Author` to be used as a dynamic migration.
extension Author: Migration { }
/// Allows `Author` to be encoded to and decoded from HTTP messages.
extension Author: Content { }
/// Allows `Author` to be used as a dynamic parameter in route definitions.
extension Author: Parameter { }
