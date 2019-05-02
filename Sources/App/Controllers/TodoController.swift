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
    
    let baseUrl = "https://jsonplaceholder.typicode.com/todos"
    
    func boot(router: Router) throws {
        
        let todoGroup = router.grouped("todos")
        todoGroup.get(use: list)
        todoGroup.get(Todo.parameter, use: show)
        
    }
    
    func list(_ request: Request) throws -> Future<[Todo]> {
        
        let client = try request.make(Client.self)
        let response = client.get(baseUrl)

        return response.flatMap(to: [Todo].self) { response in
            return try response.content.decode([Todo].self)
        }
        
    }
    
    func show(_ request: Request) throws -> Future<Todo> {

        let client = try request.make(Client.self)
        let todoNumber = try request.parameters.next(Todo.self)
        
        let response = client.get(baseUrl + "/" + String(todoNumber))
        
        // Transforms the `Future<Response>` to `Future<Todo>`
        return response.flatMap(to: Todo.self) { response in
            print(response.content)
            return try response.content.decode(Todo.self)
        }
        
    }
    
}
