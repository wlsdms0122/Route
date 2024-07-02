// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Route",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Route",
            targets: [
                "Route"
            ]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Route",
            dependencies: []
        ),
        .testTarget(
            name: "RouteTests",
            dependencies: [
                "Route"
            ]
        )
    ]
)
