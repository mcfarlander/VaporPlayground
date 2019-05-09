// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Book",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on postgres.
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),

	    // 👤 Authentication and Authorization framework for Fluent.
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0"),
        
        /// 💻 APIs for creating interactive CLI tools.
        .package(url: "https://github.com/vapor/console.git", from: "3.0.0"),
        
        .package(url: "https://github.com/vapor-community/swiftybeaver-provider.git", from: "3.0.0"),
        
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentPostgreSQL", "Vapor", "Authentication", "Command", "Logging", "SwiftyBeaverProvider"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

