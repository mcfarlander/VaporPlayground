//
//  migrate.swift
//  App
//
//  Created by Dave Johnson on 5/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL

/// Configuration of the database migrations.
///
/// - Parameter migrations: the db migrations
/// - Throws: any error
public func migrate(migrations: inout MigrationConfig) throws {
	
	migrations.add(model: User.self, database: .psql)
	migrations.add(model: UserToken.self, database: .psql)
	migrations.add(model: UserToken.self, database: .psql)
	migrations.add(model: Author.self, database: .psql)
	migrations.add(model: Work.self, database: .psql)

}
