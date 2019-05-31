//
//  RedisController.swift
//  App
//
//  Created by Dave Johnson on 5/27/19.
//

import Foundation
import Vapor
import SwiftyBeaverProvider

/// A controller to demonstrate interactions with a cache.
final class CacheController: RouteCollection {
	
	fileprivate let cacheKeyDate = "key_date"
	
	/// Define routes.
	///
	/// - Parameter router: the application route
	/// - Throws: any error
	func boot(router: Router) throws {
		
		let cache = router.grouped("cache")
		cache.get("set", use: setCache)
		cache.get("get", use: getCache)
		
	}
	
	/// Get the last date set in the cache
	///
	/// - Parameter request: the request
	/// - Returns: the database version view
	/// - Throws: any error
	func getCache(_ request: Request) throws -> Future<String> {
		
		return try request.make(KeyedCache.self).get(self.cacheKeyDate, as: String.self)
			.unwrap(or: Abort(.badRequest, reason: "No date set in cache."))
		
	}
	
	/// Set the current date in the cache
	///
	/// - Parameter request: the request
	/// - Returns: the database version view
	/// - Throws: any error
	func setCache(_ request: Request) throws -> Future<HTTPStatus> {

		let dateformatter = DateFormatter()
		dateformatter.dateStyle = .short
		dateformatter.timeStyle = .short
		let nowString = dateformatter.string(from: Date())
		
		return try request.make(KeyedCache.self).set(self.cacheKeyDate, to: nowString).transform(to: .ok)

	}
	
}
