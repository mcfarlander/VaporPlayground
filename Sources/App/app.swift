//
//  app.swift
//  App
//
//  Created by iMac 21inch on 3/2/19.
//

import Vapor

/// Creates an instance of `Application`. This is called from `main.swift` in the run target.
///
/// - Parameter env: environoment to run under (test, prod, etc)
/// - Returns: the application instance
/// - Throws: error while starting the application
public func app(_ env: Environment) throws -> Application {
    var config = Config.default()
    var env = env
    var services = Services.default()
    try configure(&config, &env, &services)
    let app = try Application(config: config, environment: env, services: services)
    try boot(app)
    return app
}
