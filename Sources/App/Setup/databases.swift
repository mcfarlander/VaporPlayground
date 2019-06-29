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
	
	// looking for a json file at the working path  ./Config/postgres.json
	let directory = DirectoryConfig.detect()
	let configDir = "Config"
	let configFile = "postgres.json"
	
	do {
		let data = try Data(contentsOf: URL(fileURLWithPath: directory.workDir)
			.appendingPathComponent(configDir, isDirectory: true)
			.appendingPathComponent(configFile, isDirectory: false))
		
		let pgConfig = try JSONDecoder().decode(PgDbConfig.self, from: data)
		
		// Configure a Postgres database
		let configDatabase = PostgreSQLDatabaseConfig(
			hostname: pgConfig.host!,
			port: pgConfig.port!,
			username: pgConfig.user!,
			database: pgConfig.database!,
			password: pgConfig.password!,
			transport: .cleartext)
		
		//	let configPostgres = PostgreSQLDatabaseConfig(url: configPostgresUrl, transport: .cleartext)
		let postgres = PostgreSQLDatabase(config: configDatabase)
		
		config.add(database: postgres, as: .psql)
		
		
	} catch {
		print(error)
	}
	
	
}
