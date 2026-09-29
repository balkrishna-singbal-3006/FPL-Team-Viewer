// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TeamSquad",
    platforms: [.iOS(.v26)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TeamSquad",
            targets: ["TeamSquad"]
        ),
    ],
    dependencies: [
        .package(path: "../PluginAPIs")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TeamSquad",
            dependencies: [
                // 2. Add the PluginAPIs library product as a target dependency
                .product(name: "PluginAPIs", package: "PluginAPIs")
            ]
        ),
        .testTarget(
            name: "TeamSquadTests",
            dependencies: ["TeamSquad"]
        ),
    ]
)
