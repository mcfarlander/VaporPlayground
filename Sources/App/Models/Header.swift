//
//  Header.swift
//  App
//
//  Created by Dave Johnson on 6/2/19.
//

import Foundation
import Vapor

/// Header model of headers within HTTP requests.
struct Header: Codable {
	var name:String
	var value:String
}

/// Allows `Header` to be encoded to and decoded from HTTP messages.
extension Header: Content { }
