//
//  Todo.swift
//  App
//
//  Created by iMac 21inch on 5/1/19.
//

import Foundation
import Vapor

struct Todo: Codable {
    var userId:Int
    var id:Int
    var title:String
    var completed:Bool
}

extension Todo: Content { }
