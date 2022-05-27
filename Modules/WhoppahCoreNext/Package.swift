// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhoppahCoreNext",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "WhoppahCoreNext",
            type: .dynamic,
            targets: ["WhoppahCoreNext"]),
    ],
    dependencies: [
        .package(name: "WhoppahModel", path: "../WhoppahModel"),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.1.2")
    ],
    targets: [
        .target(
            name: "WhoppahCoreNext",
            dependencies: [
                .product(name: "Resolver-Dynamic", package: "Resolver"),
                .product(name: "WhoppahModel", package: "WhoppahModel")
            ]),
        .testTarget(
            name: "WhoppahCoreNextTests",
            dependencies: ["WhoppahCoreNext"]),
    ]
)
