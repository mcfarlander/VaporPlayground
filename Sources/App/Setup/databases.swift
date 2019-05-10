//
//  databases.swift
//  App
//
//  Created by Dave Johnson on 5/10/19.
//

import FluentPostgreSQL
import Vapor

/// Configuration for the PostgreSQL database.
///
/// - Parameter config: the application configuration
/// - Throws: any error
public func databases(config: inout DatabasesConfig) throws {
	
	// Configure a Postgres database
	// TODO: change the config to an external JSON file!
	let configDatabase = PostgreSQLDatabaseConfig(
		hostname: "localhost",
		port: 5432,
		username: "postgres",
		database: "book",
		password: "postgres",
		transport: .cleartext)
	
	//	let configPostgresUrl = URL(fileURLWithPath: directory.workDir)
	//		.appendingPathComponent(configDir, isDirectory: true).appendingPathComponent("postgres.json").path
	//
	//	let configPostgres = PostgreSQLDatabaseConfig(url: configPostgresUrl, transport: .cleartext)
	let postgres = PostgreSQLDatabase(config: configDatabase)
	
	config.add(database: postgres, as: .psql)
	
}
