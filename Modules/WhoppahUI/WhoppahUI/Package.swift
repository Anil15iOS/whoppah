// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhoppahUI",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "WhoppahUI",
            type: .dynamic,
            targets: ["WhoppahUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.2.0"),
        .package(url: "https://github.com/art-technologies/swift-focuser", from: "0.1.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", .upToNextMajor(from: "3.3.3")),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.5.0"),
        .package(url: "https://github.com/alexrvarela/SwiftTweener.git", .upToNextMajor(from: "2.1.1")),
        .package(name: "WhoppahModel", path: "../../WhoppahModel"),
        .package(name: "WhoppahLocalization", path: "../../WhoppahLocalization")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WhoppahUI",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Focuser", package: "swift-focuser"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
                .product(name: "Resolver-Dynamic", package: "Resolver"),
                .product(name: "Tweener", package: "SwiftTweener"),
                .product(name: "WhoppahModel", package: "WhoppahModel"),
                .product(name: "WhoppahLocalization", package: "WhoppahLocalization")
            ],
            resources: [
                .process("Resources/Fonts/Poppins-Regular.ttf"),
                .process("Resources/Fonts/Poppins-SemiBold.ttf"),
                .process("Resources/Fonts/Roboto-Regular.ttf"),
                .process("Resources/Fonts/Roboto-Bold.ttf"),
                .process("Resources/Fonts/Roboto-Italic.ttf"),
                .process("Resources/Fonts/Roboto-Medium.ttf")
            ]
            ),
        .testTarget(
            name: "WhoppahUITests",
            dependencies: ["WhoppahUI"]),
    ]
)
