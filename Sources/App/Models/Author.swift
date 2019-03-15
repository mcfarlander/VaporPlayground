//
//  Authors.swift
//  App
//
//  Created by iMac 21inch on 3/2/19.
//

import Foundation
import FluentPostgreSQL
import Vapor

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

// Allows `Author` to be used as a dynamic migration.
extension Author: Migration { }
/// Allows `Author` to be encoded to and decoded from HTTP messages.
extension Author: Content { }
/// Allows `Author` to be used as a dynamic parameter in route definitions.
extension Author: Parameter { }
