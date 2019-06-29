//
//  PgDbConfig.swift
//  App
//
//  Created by Dave on 6/29/19.
//

import Foundation


struct PgDbConfig: Codable {
	let host: 		String?
	let port: 		Int?
	let database: 	String?
	let user: 		String?
	let password: 	String?
}
