//
//  commands.swift
//  App
//
//  Created by Dave Johnson on 5/10/19.
//

import Foundation
import Vapor


/// Configuration of the commands.
///
/// - Parameter config: the application's configuration
public func commands(config: inout CommandConfig) {
	
	config.use(CowsayCommand(), as: "cowsay")

}
