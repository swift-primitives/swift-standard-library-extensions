// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-standard-library-extensions",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Standard Library Extensions",
            targets: ["Standard Library Extensions"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-test-primitives.git", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "Standard Library Extensions"
        ),
        .testTarget(
            name: "Standard Library Extensions Tests",
            dependencies: [
                "Standard Library Extensions",
                .product(name: "Test Primitives", package: "swift-test-primitives"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
