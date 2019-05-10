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
    
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
	
	//// Command Config
	var commandsConfig = CommandConfig.default()
	commands(config: &commandsConfig)
	services.register(commandsConfig)
	
	// Register the configured PostgreSQL database
	var databasesConfig = DatabasesConfig()
	try databases(config: &databasesConfig)
	services.register(databasesConfig)
	
	// Register middleware
	var middlewaresConfig = MiddlewareConfig()
	try middlewares(config: &middlewaresConfig)
	services.register(middlewaresConfig)
	
	// Configure migrations
	services.register { container -> MigrationConfig in
		var migrationConfig = MigrationConfig()
		try migrate(migrations: &migrationConfig)
		return migrationConfig
	}
	
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)


    // Configure SwiftyBeaver (logging)
	// Define the configuration directory to the project
	let directory = DirectoryConfig.detect()
	let configDir = "Sources/App/Config"
    
	// Setup your destinations: console and file
	// TODO: make the configuration of the logs more dynamic
    let console = ConsoleDestination()
    console.minLevel = .debug 				// update properties according to your needs

	let file = FileDestination()  			// log to file
	file.logFileURL = URL(string: "file:///Users/dave/logs/VaporLogs.log")! // change this to set log file!

    // Register the logger
    services.register(SwiftyBeaverLogger(destinations: [console, file]), as: Logger.self)

    
    // register Authentication provider
    try services.register(AuthenticationProvider())

    
}
