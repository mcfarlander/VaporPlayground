//
//  configure.swift
//  App
//
//  Created by iMac 21inch on 3/2/19.
//

import Authentication
import FluentPostgreSQL
import Vapor

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

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a Postgres database
    let config = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "postgres", database: "book", password: "postgres", transport: .cleartext)
    let postgres = PostgreSQLDatabase(config: config)

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
