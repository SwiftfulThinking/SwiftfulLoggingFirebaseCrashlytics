// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftfulLoggingFirebaseCrashlytics",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftfulLoggingFirebaseCrashlytics",
            targets: ["SwiftfulLoggingFirebaseCrashlytics"]),
    ],
    dependencies: [
        // Here we add the dependency for the SendableDictionary package
        .package(url: "https://github.com/SwiftfulThinking/SwiftfulLogging.git", "1.0.0"..<"2.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", "12.0.0"..<"13.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftfulLoggingFirebaseCrashlytics",
            dependencies: [
                .product(name: "SwiftfulLogging", package: "SwiftfulLogging"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk")
            ]
        ),
        .testTarget(
            name: "SwiftfulLoggingFirebaseCrashlyticsTests",
            dependencies: ["SwiftfulLoggingFirebaseCrashlytics"]
        ),
    ]
)
