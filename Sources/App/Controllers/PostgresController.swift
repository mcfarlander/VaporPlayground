//
//  PostgresController.swift
//  App
//
//  Created by Dave Johnson on 5/25/19.
//

import Foundation
import Vapor
import HTTP
import SwiftyBeaverProvider

/// A controller to demonstrate interactions with the PostgreSQL server.
final class PostgresController: RouteCollection {
	
	/// Define routes.
	///
	/// - Parameter router: the application route
	/// - Throws: any error
	func boot(router: Router) throws {
		
		let postgres = router.grouped("postgres")
		postgres.get("version", use: version)
		
	}
	
	/// Get version of the database server.
	///
	/// - Parameter request: the request
	/// - Returns: the database version view
	/// - Throws: any error
	func version(_ request: Request) throws -> Future<String> {
		
		return request.withPooledConnection(to: .psql){ conn in
			return conn.raw("SELECT version()").all(decoding: PostgreSQLVersion.self)}.map { rows in
				return rows[0].version
			}
		
	}

}
