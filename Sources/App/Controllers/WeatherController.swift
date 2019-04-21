//
//  WeatherController.swift
//  App
//
//  Created by iMac 21inch on 4/21/19.
//

import Foundation
import Vapor

final class WeatherController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let weather = router.grouped("weather")
        weather.get(use: list)
        
    }
    
    func list(_ request: Request) throws -> String {
        return "The weather today will suck."
    }
    
    


}
