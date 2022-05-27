// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhoppahDataStore",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WhoppahDataStore",
            type: .dynamic,
            targets: ["WhoppahDataStore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios", from: "0.50.0"),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.1.2"),
        .package(name: "WhoppahModel", path: "../WhoppahModel"),
        .package(name: "WhoppahCoreNext", path: "../WhoppahCoreNext"),
        .package(name: "WhoppahRepository", path: "../WhoppahRepository")
    ],
    targets: [
        .target(
            name: "WhoppahDataStore",
            dependencies: [
                .product(name: "Apollo-Dynamic", package: "apollo-ios"),
                .product(name: "Resolver-Dynamic", package: "Resolver"),
                .product(name: "WhoppahCoreNext", package: "WhoppahCoreNext"),
                .product(name: "WhoppahModel", package: "WhoppahModel"),
                .product(name: "WhoppahRepository", package: "WhoppahRepository"),
            ]),
        .testTarget(
            name: "WhoppahDataStoreTests",
            dependencies: ["WhoppahDataStore"]),
    ]
)
