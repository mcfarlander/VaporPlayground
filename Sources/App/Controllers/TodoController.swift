//
//  WeatherController.swift
//  App
//
//  Created by iMac 21inch on 4/21/19.
//

import Foundation
import Vapor
import HTTP

final class TodoController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let todoGroup = router.grouped("todos")
        todoGroup.get(use: get)
        
    }
    
    func get(_ request: Request) throws -> Future<Todo> {

        let client = try request.make(Client.self)
        let response = client.get("https://jsonplaceholder.typicode.com/todos/1")
        
        // Transforms the `Future<Response>` to `Future<Todo>`
        return response.flatMap(to: Todo.self) { response in
            print(response.content)
            return try response.content.decode(Todo.self)
        }
        
    }
    
}
