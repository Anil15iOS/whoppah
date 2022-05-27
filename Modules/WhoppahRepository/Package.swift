// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhoppahRepository",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WhoppahRepository",
            type: .dynamic,
            targets: ["WhoppahRepository"]),
    ],
    dependencies: [
        .package(name: "WhoppahModel", path: "../WhoppahModel")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WhoppahRepository",
            dependencies: [
                .product(name: "WhoppahModel", package: "WhoppahModel")
            ]),
        .testTarget(
            name: "WhoppahRepositoryTests",
            dependencies: ["WhoppahRepository"]),
    ]
)
