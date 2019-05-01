//
//  routes.swift
//  App
//
//  Created by iMac 21inch on 3/2/19.
//

import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    try router.register(collection: AuthorController())
    try router.register(collection: WorkController())
    try router.register(collection: WeatherController())

}
