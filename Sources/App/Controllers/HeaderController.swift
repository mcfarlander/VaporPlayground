//
//  HeaderController.swift
//  App
//
//  Created by Dave Johnson on 6/2/19.
//

import Foundation
import Vapor


/// A controller to demonstrate interactions with headers.
final class HeaderController: RouteCollection {
	
	/// Define routes.
	///
	/// - Parameter router: the application route
	/// - Throws: any error
	func boot(router: Router) throws {
		
		let headers = router.grouped("headers")
		headers.get(use: getHeaders)
		
	}
	
	/// Get headers sent to this request.
	///
	/// - Parameter request: the request
	/// - Returns: a string of all the headers
	/// - Throws: any error
	func getHeaders(_ request: Request) throws -> [Header] {
		
		var headers:[Header] = []
		
		for header in request.http.headers {
			let passedHeader = Header(name: header.name, value: header.value)
			headers.append(passedHeader)
		}
		
		return headers
		
	}
	
}

