// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DiffedArrayDataProvider",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_12),
        .tvOS(.v11),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "DiffedArrayDataProvider",
            targets: ["DiffedArrayDataProvider"]),
    ],
    dependencies: [
        .package(url: "https://github.com/lightsprint09/Sourcing", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "DiffedArrayDataProvider",
            dependencies: ["Sourcing"],
            path: "Source"),
        .testTarget(
            name: "DiffedArrayDataProviderTests",
            dependencies: ["DiffedArrayDataProvider"],
            path: "Tests"),
    ]
)

