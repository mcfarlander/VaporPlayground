//
//  WeatherController.swift
//  App
//
//  Created by iMac 21inch on 4/21/19.
//

import Foundation
import Vapor
import HTTP

struct Todo: Codable {
    var userId:Int
    var id:Int
    var title:String
    var completed:Bool
}

extension Todo: Content { }

final class WeatherController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let weather = router.grouped("weather")
        weather.get(use: get)
        
    }
    
    func get(_ request: Request) throws -> Future<Todo> {

        let client = try request.make(Client.self)
        let response = client.get("https://jsonplaceholder.typicode.com/todos/1")
        
        // Transforms the `Future<Response>` to `Future<Todo>`
        return response.flatMap(to: Todo.self) { response in
            print(response.content)
            return try response.content.decode(Todo.self)
        }

        // return "this sucks"
        
    }
    
}
