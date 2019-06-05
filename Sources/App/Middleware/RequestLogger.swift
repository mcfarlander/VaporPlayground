//
//  RequestLogger.swift
//  App
//
//  Created by Dave on 6/4/19.
//

import Foundation
import Vapor
import SwiftyBeaverProvider

/// Middleware to log all requests.
final class RequestLogger: Middleware {
	
	
	/// On all requests, log them using SwiftyBeaver.
	///
	/// - Parameters:
	///   - request: the incoming request
	///   - next: the next function on the request chain
	/// - Returns: the response
	/// - Throws: any error
	func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {

		let logger: Logger = try request.make(SwiftyBeaverLogger.self)
		
		let dateformatter = DateFormatter()
		dateformatter.dateStyle = .short
		dateformatter.timeStyle = .short
		let nowString = dateformatter.string(from: Date())
		
		let requestInfo = "\(request.http.method.string) \(request.http.url.path)" + (request.http.url.query.map { "?\($0)" } ?? "")
		
		return try next.respond(to: request).map { response in
			logger.debug("\(nowString) \(requestInfo)")
			return response
		}
		
	}
	
}

// MARK: - RequestLogger service definition.
extension RequestLogger: ServiceType {
	
	/// Create the service for the RequestLogger
	///
	/// - Parameter container: the request container
	/// - Returns: return the RequestLogger
	/// - Throws: any error
	static func makeService(for container: Container) throws -> RequestLogger {
		return RequestLogger()
	}
}
