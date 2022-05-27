// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhoppahLocalization",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "WhoppahLocalization",
            type: .dynamic,
            targets: ["WhoppahLocalization"]),
    ],
    dependencies: [
        .package(name: "WhoppahModel", path: "../WhoppahModel"),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.5.0")
    ],
    targets: [
        .target(
            name: "WhoppahLocalization",
            dependencies: [
                .product(name: "Resolver-Dynamic", package: "Resolver"),
                .product(name: "WhoppahModel", package: "WhoppahModel")
            ]),
        .testTarget(
            name: "WhoppahLocalizationTests",
            dependencies: ["WhoppahLocalization"]),
    ]
)
