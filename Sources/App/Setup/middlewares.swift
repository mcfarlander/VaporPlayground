//
//  middlewares.swift
//  App
//
//  Created by Dave Johnson on 5/10/19.
//

import Foundation
import Vapor


/// Configuration of middleware for the application.
///
/// - Parameter config: the application's configuration
/// - Throws: any errors
public func middlewares(config: inout MiddlewareConfig) throws {
	
	config.use(FileMiddleware.self) // Serves files from `Public/` directory
	config.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response

}
