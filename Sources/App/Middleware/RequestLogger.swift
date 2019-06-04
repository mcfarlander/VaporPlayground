//
//  RequestLogger.swift
//  App
//
//  Created by Dave on 6/4/19.
//

import Foundation
import Vapor
import SwiftyBeaverProvider

final class RequestLogger: Middleware {
	
	
	func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {

		let logger: Logger = try request.make(SwiftyBeaverLogger.self)
		
		let startTime = Date()
		let requestInfo = "\(request.http.method.string) \(request.http.url.path)" + (request.http.url.query.map { "?\($0)" } ?? "")
		
		return try next.respond(to: request).map { response in
			logger.debug("\(startTime) \(requestInfo)")
			return response
		}
		
	}
	
}

extension RequestLogger: ServiceType {
	
	static func makeService(for container: Container) throws -> RequestLogger {
		return RequestLogger()
	}
}
