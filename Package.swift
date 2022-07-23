// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Represent",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Represent",
            targets: [
                "Represent"
            ]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Represent",
            dependencies: []
        ),
        .testTarget(
            name: "RepresentTests",
            dependencies: [
                "Represent"
            ]
        )
    ]
)
