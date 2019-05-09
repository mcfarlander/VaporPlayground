//
//  WeatherController.swift
//  App
//
//  Created by Dave Johnson on 4/21/19.
//

import Foundation
import Vapor
import HTTP

/// A controller to demonstrate interactions with a remote service. The controller
/// will interact with the TODO example web service to get a list of Todo objects.
/// It can also "mock" a request to a specfic Todo object.
final class TodoController: RouteCollection {
    
    /// The remote base URL.
    let baseUrl = "https://jsonplaceholder.typicode.com/todos"
    
    /// Define 2 routes: one to get all the Todos and another to get a specific Todo.
    ///
    /// - Parameter router: the application route
    /// - Throws: any error
    func boot(router: Router) throws {
        
        let todoGroup = router.grouped("todos")
        todoGroup.get(use: list)
        todoGroup.get(Todo.parameter, use: show)
        
    }
    
    /// Get a complete list of all Todo objects from the remote service.
    ///
    /// - Parameter request: the request
    /// - Returns: a list of Todos
    /// - Throws: any error
    func list(_ request: Request) throws -> Future<[Todo]> {
        
        let client = try request.make(Client.self)
        let response = client.get(baseUrl)

        return response.flatMap(to: [Todo].self) { response in
            return try response.content.decode([Todo].self)
        }
        
    }
    
    /// Get a specific Todo object. Taking the parameter from the request
    /// to THIS server and creating a URL get the actual Todo.
    ///
    /// - Parameter request: the request
    /// - Returns: the specific Todo from the remote service
    /// - Throws: any error
    func show(_ request: Request) throws -> Future<Todo> {

        // 1. create a client
        let client = try request.make(Client.self)
        
        // 2. get the parameter from THIS request
        let todoNumber = try request.parameters.next(Todo.self)
        
        // 3. create a URL for the REMOTE service
        let response = client.get(baseUrl + "/" + String(todoNumber))
        
        // 4. perform the GET and map back to a object to view from THIS server
        
        // Transforms the `Future<Response>` to `Future<Todo>`
        return response.flatMap(to: Todo.self) { response in
            print(response.content)
            return try response.content.decode(Todo.self)
        }
        
    }
    
}
