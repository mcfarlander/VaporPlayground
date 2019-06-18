//
//  routes.swift
//  App
//
//  Created by Dave Johnson on 3/2/19.
//

import Vapor

/// Register your application's routes here.
///
/// - Parameter router: the router (defined routes)
/// - Throws: any error while setting the routes
public func routes(_ router: Router) throws {
    
    // Basic "It works" example
    router.get { req in
        return "Vapor Playground!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
	
	// Basic view example
	router.get("home") { req -> Future<View> in
		return try req.view().render("home")
	}
    
    // actual routes defined in the controllers !!!
	try router.register(collection: PostgresController())
	try router.register(collection: CacheController())
	try router.register(collection: HeaderController())
	try router.register(collection: UserController())
    try router.register(collection: AuthorController())
    try router.register(collection: WorkController())
    try router.register(collection: TodoController())

}
