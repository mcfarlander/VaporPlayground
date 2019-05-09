//
//  CowsayCommand.swift
//  App
//
//  Created by Dave Johnson on 5/4/19.
//

import Foundation
import Command

/// Generates ASCII picture of a cow with a message.
struct CowsayCommand: Command {
    
    /// See `Command`
    var arguments: [CommandArgument] {
        return [.argument(name: "message")]
    }
    
    var options: [CommandOption] {
        return [
            .value(name: "eyes", short: "e", default: "oo", help: ["Change cow's eyes"]),
            .value(name: "tongue", short: "t", default: " ", help: ["Change cow's tongue"]),
        ]
    }
    
    var help: [String] {
        return ["Generates ASCII picture of a cow with a message."]
    }
    
    func run(using context: CommandContext) throws -> Future<Void> {
        let message = try context.argument("message")
        /// We can use requireOption here since both options have default values
        let eyes = try context.requireOption("eyes")
        let tongue = try context.requireOption("tongue")
        let padding = String(repeating: "-", count: message.count)
        let text: String = """
        \(padding)
        < \(message) >
        \(padding)
        \\   ^__^
        \\  (\(eyes)\\_______
        (__)\\       )\\/\\
        \(tongue)  ||----w |
        ||     ||
        """
        context.console.print(text)
        return .done(on: context.container)
    }
    
}
