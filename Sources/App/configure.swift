//
//  configure.swift
//  App
//
//  Created by Dave Johnson on 3/2/19.
//

import Authentication
import FluentPostgreSQL
import Vapor
import SwiftyBeaverProvider

/// Called before your application initializes.
///
/// - Parameters:
///   - config: the configuration of the application
///   - env: the environment for the application (test, prod, etc)
///   - services: the services of the application
/// - Throws: any error during startup
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
	
	// Define the configuration directory to the project
	let directory = DirectoryConfig.detect()
	let configDir = "Sources/App/Config"
    
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure SwiftyBeaver (logging)
    
	// Setup your destinations: console and file
	// TODO: make the configuration of the logs more dynamic
    let console = ConsoleDestination()
    console.minLevel = .debug 				// update properties according to your needs

	let file = FileDestination()  			// log to file
	file.logFileURL = URL(string: "file:///Users/dave/logs/VaporLogs.log")! // change this to set log file!

    // Register the logger
    services.register(SwiftyBeaverLogger(destinations: [console, file]), as: Logger.self)


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

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgres, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: UserToken.self, database: .psql)
    migrations.add(model: Author.self, database: .psql)
    migrations.add(model: Work.self, database: .psql)
    services.register(migrations)
    
    // register Authentication provider
    try services.register(AuthenticationProvider())
    
    /// Create a `CommandConfig` with default commands.
    var commandConfig = CommandConfig.default()
    commandConfig.use(CowsayCommand(), as: "cowsay")
    services.register(commandConfig)
    
    
}
