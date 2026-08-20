// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-standard-library-extensions",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Standard Library Extensions",
            targets: ["Standard Library Extensions"]
        ),
        .library(
            name: "Standard Library Extensions Test Support",
            targets: ["Standard Library Extensions Test Support"]
        ),
    ],
    targets: [
        .target(
            name: "Standard Library Extensions"
        ),
        // Tests are in a separate nested package (Tests/Package.swift)
        // to break the circular dependency with swift-testing
        .target(
            name: "Standard Library Extensions Test Support",
            dependencies: [
                "Standard Library Extensions"
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Standard Library Extensions Tests",
            dependencies: [
                "Standard Library Extensions",
                "Standard Library Extensions Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
